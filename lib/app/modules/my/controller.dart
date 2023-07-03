import 'package:get/get.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class MyController extends GetxController {
  final _userService = UserService.to;

  void logout() {
    _userService.logout();
  }
}
