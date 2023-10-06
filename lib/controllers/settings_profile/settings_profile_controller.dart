import 'package:get/get.dart';

class SettingsProfileController extends GetxController {
  String _name = "Akash";
  String _email = "goelakash44@gmail.com";

  void updateUserData(String name, String email) {
    _name = name;
    _email = email;
    update();
  }

  String get getName => _name;

  String get getEmail => _email;
}
