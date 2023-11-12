import 'dart:async';

import 'package:get/get.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';
import 'package:ziggle/app/data/provider/fcm.dart';
import 'package:ziggle/app/data/services/token/repository.dart';
import 'package:ziggle/app/data/services/user/repository.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();
  final UserRepository _repository;
  final TokenRepository _tokenRepository;
  final FcmProvider _fcmProvider;
  UserInfoResponse? _user;
  bool _skipLogin = false;
  final _controller = StreamController<UserInfoResponse?>.broadcast();
  final _waitFirst = Completer<void>();

  // bool get recentLogout => _repository.recentLogout;

  UserService(this._repository, this._tokenRepository, this._fcmProvider) {
    _controller.stream.listen((user) async {
      _user = user;
      Get.offAllNamed(
        (user == null && !_skipLogin) ? Paths.login : Paths.root,
      );
      final fcmToken =
          await _fcmProvider.getFcmToken().firstWhere((token) => token != null);
      await _repository.updateFcmToken(fcmToken as String);
    });
    _tokenRepository.getToken().listen((event) {
      _updateUser();
    });
  }

  Future<void> loginWithCode(String code) async {
    // final token = await _repository.loginWithCode(code);
    // await _tokenRepository.saveToken(token);
    // await _repository.setRecentLogout(false);
  }

  Future<void> logout() async {
    // _skipLogin = false;
    // await _tokenRepository.deleteToken();
    // await _repository.setRecentLogout();
  }

  Future<UserInfoResponse?> _updateUser() async {
    try {
      final user = await _fetchUserInfo();
      _controller.add(user);
      return user;
    } catch (_) {
      _controller.add(null);
      return null;
    } finally {
      if (!_waitFirst.isCompleted) _waitFirst.complete();
    }
  }

  Future<UserInfoResponse?> _fetchUserInfo() async {
    final token = await _tokenRepository.getToken().first;
    if (token == null) {
      return null;
    }

    return null;
    // return await _repository.userInfo();
  }

  Stream<UserInfoResponse?> getUserInfo() async* {
    await _waitFirst.future;
    yield _user;
    yield* _controller.stream;
  }

  void skipLogin() {
    _skipLogin = true;
    _controller.add(null);
  }
}
