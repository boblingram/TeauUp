import 'dart:developer';

import 'package:graphql/client.dart';

import 'Constants.dart';

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    Constants.BASEURL,
    defaultHeaders: {Constants.HEADER_API_KEY: Constants.API_KEY},
  );

  static final GraphQLClient tempClient = GraphQLClient(
    cache: GraphQLCache(),
    link: _httpLink,
  );

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

}