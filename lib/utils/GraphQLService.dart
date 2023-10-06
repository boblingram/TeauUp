import 'dart:convert';
import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:teamup/models/AuthTokenModel.dart';
import 'package:teamup/utils/app_strings.dart';

import 'Constants.dart';

//WA - With Authorization

class GraphQLService {

  static String jwtToken = '';

  static final GraphQLClient tempWAClient = GraphQLClient(link: _httpWALink, cache: GraphQLCache());

  static final HttpLink _httpWALink = HttpLink(
    Constants.BASEURL,
    defaultHeaders: {Constants.HEADER_API_KEY: Constants.API_KEY,'Authorization': 'Bearer $jwtToken',},
  );

  static final HttpLink _httpLink = HttpLink(
    Constants.BASEURL,
    defaultHeaders: {Constants.HEADER_API_KEY: Constants.API_KEY},
  );

  static final GraphQLClient tempClient = GraphQLClient(
    cache: GraphQLCache(),
    link: _httpLink,
  );

  static bool isTokenExpired(){
    print("Token Validation Started");
    if(jwtToken.isEmpty){
      return true;
    }
    return JwtDecoder.isExpired(jwtToken);
  }

  // Method to make a GraphQL request with token check
  static Future<QueryResult> makeGraphQLRequest(QueryOptions options) async {
    if (isTokenExpired()) {
      // Token has expired, handle accordingly (e.g., refresh the token)
      print("Token Expired Need to Generate New Token");
      await regenerateToken();
    }
    return tempWAClient.query(options);
  }

  static Future<QueryResult> makeGraphMRequest(MutationOptions options)async {
    if (isTokenExpired()) {
      // Token has expired, handle accordingly (e.g., refresh the token)
      print("Token Expired Need to Generate New Token");
      await regenerateToken();
    }
    return tempWAClient.mutate(options);
  }

  static Future<bool> regenerateToken() async {
    DateTime now = DateTime.now();
    // Convert the DateTime to a Unix timestamp (seconds since Epoch).
    int unixTimestamp = now.toUtc().millisecondsSinceEpoch ~/ 1000;

    int endUnixTimeStamp = now.add(Duration(seconds: 45)).toUtc().millisecondsSinceEpoch ~/ 1000;
    var localStorage = GetStorage();
    var localClientId = localStorage.read(AppStrings.localClientIdValue);
    var localDeviceId = localStorage.read(AppStrings.localDeviceIdValue);
    var localFingerprint = localStorage.read(AppStrings.localFingerprintValue);
    var localAuthKey = localStorage.read(AppStrings.localAuthkeyValue);
    //log("Old JWT $jwtToken User id is $localClientId");
    /*var tempJWT = JWT({
      'sub': 'auth/getToken',
      'name': '$localClientId',
      "iat": "$unixTimestamp",
      "userId":"$localClientId",
      "jit":"<random-uniquenumber for logs",
      "data":"$localDeviceId+”_~”+ $localFingerprint>",
      "exp":"$endUnixTimeStamp",
      "iss":"https://www.teamup.com/keyproxy"
    },
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',);
*/
    var tempJWT = JWT({
      'sub': 'auth/getToken',
      'name': '$localClientId',
      "iat": "$unixTimestamp",
      "userId":"$localClientId",
      "jit":"<random-uniquenumber for logs",
      "data":"$localDeviceId+”_~”+ $localFingerprint>",
    });

    //log("Auth Key is ${localAuthKey}");
    //There is no need to add this as this is already present and we need to decode it
    //String privateKey = '''-----BEGIN RSA PRIVATE KEY-----\n${localAuthKey.toString()}\n-----END RSA PRIVATE KEY-----\n''';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String privKeyPem=stringToBase64.decode(localAuthKey.toString());
    //log("JWT Token is ${tempJWT.payload}");
    var assertJWT = tempJWT.sign(RSAPrivateKey(privKeyPem),algorithm: JWTAlgorithm.RS256, expiresIn: Duration(minutes: 300));
    //print("New Generate Assert value is $assertJWT");

    String assertQuery = '''query MyQuery {
      authToken(assert: "$assertJWT"){
    JWTString
    authKey
  }
    }''';

    var result = await GraphQLService.tempWAClient
        .query(QueryOptions(document: gql(assertQuery)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "Assert Query Failed");
      return false;
    }
    AssertTokenModel assertTokenModel = AssertTokenModel.fromJson(result.data!);
    log("Assert Response Received ${assertTokenModel.authTokenData.jwtString}");
    jwtToken = assertTokenModel.authTokenData.jwtString.toString();
    return true;
  }


  static void parseError(OperationException? responseToShow, String apiCallFrom) {
    print("Error in $apiCallFrom");
    if (responseToShow != null && responseToShow.graphqlErrors.isNotEmpty) {
      print("Error is ${responseToShow.graphqlErrors[0].message}");
    } else {
      log("Exception is $responseToShow");
    }
  }

  static bool shouldContinueFurther(String? tempName,
      QueryResult<Object?> result,) {
    if (result.data == null || result.exception != null) {
      //No Data Received from Server;
      parseError(result.exception, "$tempName");
      return false;
    }
    return true;
  }

  // Static method to set the JWT token
  static void setJwtToken(String token) {
    jwtToken = token;
  }

  static void parseName() {
    try{
      print("Token is ${jwtToken}");
      var result = JwtDecoder.decode(jwtToken);
      print("Name is ");
      var localStorage = GetStorage();
      localStorage.write(AppStrings.localClientNameValue, "${result["name"]}");
    }catch(onError){
      print("Error While Parsing name $onError");
    }
  }
}