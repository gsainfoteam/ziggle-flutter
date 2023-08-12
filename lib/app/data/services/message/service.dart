import 'package:get/get.dart';
import 'package:ziggle/app/data/provider/fcm.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class MessageService {
  final FcmProvider _fcmProvider;
  final UserService _userService;

  MessageService(this._fcmProvider, this._userService) {
    _userService.getUserInfo().first.then((_) {
      _fcmProvider.getLink().listen((event) {
        Get.toNamed(event);
      });
    });
  }
}
