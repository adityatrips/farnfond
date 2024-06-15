import 'package:get/get.dart';

class GlobalStateController extends GetxController {
  Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});

  void updateUserData(Map<String, dynamic> data) {
    userData.value = data;
  }
}
