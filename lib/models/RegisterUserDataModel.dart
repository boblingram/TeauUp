import 'dart:convert';

RegisterUserDataModel registerUserDataModelFromJson(String str) => RegisterUserDataModel.fromJson(json.decode(str));

class RegisterUserDataModel {
  RegisterUser registerUser;

  RegisterUserDataModel({
    required this.registerUser,
  });

  factory RegisterUserDataModel.fromJson(Map<String, dynamic> json) => RegisterUserDataModel(
    registerUser: RegisterUser.fromJson(json["registerUser"]),
  );

}

class RegisterUser {
  AuthToken authToken;
  User user;
  bool isNewUser;

  RegisterUser({
    required this.authToken,
    required this.user,
    required this.isNewUser
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    authToken: AuthToken.fromJson(json["authToken"]),
    user: User.fromJson(json["user"]),
    isNewUser: json["isNewUser"] == null ? false : json["isNewUser"]
  );

  Map<String, dynamic> toJson() => {
    "authToken": authToken.toJson(),
    "user": user.toJson(),
  };
}

class AuthToken {
  var jwtString;
  var authKey;

  AuthToken({
    this.jwtString,
    this.authKey,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => AuthToken(
    jwtString: json["JWTString"],
    authKey: json["authKey"],
  );

  Map<String, dynamic> toJson() => {
    "JWTString": jwtString,
    "authKey": authKey,
  };
}

class User {
  var id;
  var ph;
  var fullname;
  var deviceId;

  User({
    this.id,
    this.ph,
    this.fullname,
    this.deviceId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    ph: json["ph"],
    fullname: json["fullname"],
    deviceId: json["deviceId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ph": ph,
    "fullname": fullname,
    "deviceId": deviceId,
  };
}