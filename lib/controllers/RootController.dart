import 'dart:convert';
import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:teamup/models/AuthTokenModel.dart';
import 'package:teamup/models/RegisterUserDataModel.dart';
import 'package:teamup/utils/Constants.dart';
import 'package:teamup/utils/Notification_Service.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/HomeView.dart';
import 'package:teamup/views/Register_View.dart';
import 'package:teamup/views/add_goals/set_goals/set_goal_page.dart';
import 'package:teamup/views/onboard/onboard_page.dart';

import '../utils/GraphQLService.dart';

class RootController extends GetxController{

  GetStorage localStorage = GetStorage();
  String deviceId = "", fingerprint = "";
  String jwtToken = "";

  void checkGeneration(){
    DateTime now = DateTime.now();
    // Convert the DateTime to a Unix timestamp (seconds since Epoch).
    int unixTimestamp = now.toUtc().millisecondsSinceEpoch ~/ 1000;

    int endUnixTimeStamp = now.add(Duration(seconds: 45)).toUtc().millisecondsSinceEpoch ~/ 1000;
    var localStorage = GetStorage();
    var localClientId = localStorage.read(AppStrings.localClientIdValue);
    var localDeviceId = localStorage.read(AppStrings.localDeviceIdValue);
    var localFingerprint = localStorage.read(AppStrings.localFingerprintValue);
    var localAuthKey = localStorage.read(AppStrings.localAuthkeyValue);
    var tempJWT = JWT({
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

    //log("Auth Key is ${localAuthKey}");
    //There is no need to add this as this is already present and we need to decode it
    //String privateKey = '''-----BEGIN RSA PRIVATE KEY-----\n${localAuthKey.toString()}\n-----END RSA PRIVATE KEY-----\n''';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String privKeyPem=stringToBase64.decode(localAuthKey.toString());
    log("Private Key is $privKeyPem");
    jwtToken = tempJWT.sign(RSAPrivateKey(privKeyPem),algorithm: JWTAlgorithm.RS256, expiresIn: Duration(minutes: 300));
    print("New Generate JWT Token in $jwtToken");
    return;
  }

  Future<void> checkAndNavigate() async {
    var localAuthKey = localStorage.read(AppStrings.localAuthkeyValue) ?? "";
    var localClientId = localStorage.read(AppStrings.localClientIdValue) ?? "";
    //print("Local Auth is $localAuthKey and local Client is $localClientId");
    if(localClientId.toString().isNotEmpty && localAuthKey.toString().isNotEmpty){
      navigateToHomeView();
      return;
    }
    var localDeviceId = localStorage.read(AppStrings.localDeviceIdValue) ?? AppStrings.emptyValue;
    var localFingerprint = localStorage.read(AppStrings.localFingerprintValue) ?? AppStrings.emptyValue;
    await callAuthTokenElevated("$localDeviceId", "$localFingerprint");
  }

  Future<void> callAuthTokenElevated(String tempD, String tempF) async{
    String query = '''query MyQuery {
  authTokenElevated(deviceId: "$tempD", fingerprint: "$tempF") {
    JWTString
    authKey
  }
}
''';
    var result = await GraphQLService.tempClient
        .query(QueryOptions(document: gql(query)));
    if( (result.data == null && result.exception != null ) || (result.data!.isEmpty) ){
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "Call Auth Token Elevated - Query");
      navigateToRegisterView();
      return;
    }
    log(result.data.toString());
    AuthTokenModel authTokenModel = AuthTokenModel.fromJson(result.data!);
    if(authTokenModel.authTokenData.jwtString.toString().isEmpty || authTokenModel.authTokenData.jwtString.toString().isEmpty){
      print("JWTString and AuthKey Not Exists");
      navigateToRegisterView();
      return;
    }
    var clientId = decodeJWTToID(authTokenModel.authTokenData.jwtString.toString());
    localStorage.write(AppStrings.localClientIdValue, clientId);
    localStorage.write(AppStrings.localAuthkeyValue, authTokenModel.authTokenData.authKey);
    navigateToHomeView(milliseconds: 100);
  }

  void newRegistrationToServer(String name) async{
    if(deviceId.isEmpty || fingerprint.isEmpty){
      print("Generation Aborted Due to Missing Data");
      return null;
    }
    var fcmValue = localStorage.read(AppStrings.localFCMValue) ?? AppStrings.emptyValue;
    print("Name is $name, DeviceId is $deviceId, FingerPrint is $fingerprint, FCM is $fcmValue");
    String mutation = '''mutation MyMutation {
  registerUser(deviceId: "$deviceId", fingerprint: "$fingerprint", fullname: "$name", FCMToken: "$fcmValue") {
    authToken {
      JWTString
      authKey
    }
    user {
      id
      ph
      fullname
      deviceId
    }
  }
}
''';
    showPLoader();
    var result = await GraphQLService.tempClient
        .mutate(MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    //json.encode(result.data);
    hidePLoader();
    if (result.data == null && result.exception != null) {
      //No Data Received from Server;
      GraphQLService.parseError(result.exception, "Register User Mutation");
      return;
    }
    log(result.data.toString());
    RegisterUserDataModel registerUserDataModel = RegisterUserDataModel.fromJson(result.data!);
    localStorage.write(AppStrings.localClientIdValue, registerUserDataModel.registerUser.user.id);
    localStorage.write(AppStrings.localAuthkeyValue, registerUserDataModel.registerUser.authToken.authKey);
    jwtToken = registerUserDataModel.registerUser.authToken.jwtString.toString();
    localStorage.write(AppStrings.localClientNameValue, name);
    navigateToOnBoardingPage();
    return;
  }

  void updateFCMToken(String value) {
    localStorage.write(AppStrings.localFCMValue, value);
  }

  void updateDeviceIdFingerprint() {
    localStorage.write(AppStrings.localDeviceIdValue, deviceId);
    localStorage.write(AppStrings.localFingerprintValue, fingerprint);
  }

  void navigateToCreateGoalPage() {
    Get.offAll(SetGoalPage(showBack: false,));
  }

  void navigateToRegisterView(){
    Get.offAll(RegisterView());
  }

  void navigateToHomeView({int milliseconds = 1000}){
    Future.delayed(Duration(milliseconds: milliseconds),(){
      Get.offAll(HomeView());
    });
  }

  void navigateToOnBoardingPage() {
    Get.offAll(OnBoardingPage());
  }

  decodeJWTToID(String tempString) {
    try{
      return JWT.decode(tempString).payload["userId"].toString();
    }catch(onError){
      print("JWT decode failed $onError");
      return "";
    }

  }

}