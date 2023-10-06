/*
{__typename: Query, authTokenElevated: {__typename: AuthToken, JWTString: , authKey: }}
 */
import 'dart:convert';

import 'RegisterUserDataModel.dart';

class AuthTokenModel {
  AuthToken authTokenData;

  AuthTokenModel({
    required this.authTokenData,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => AuthTokenModel(
    authTokenData: AuthToken.fromJson(json["authTokenElevated"]),
  );

}

class AssertTokenModel{
  AuthToken authTokenData;

  AssertTokenModel({required this.authTokenData});

  factory AssertTokenModel.fromJson(Map<String, dynamic> json) => AssertTokenModel(authTokenData: AuthToken.fromJson(json["authToken"]));
}