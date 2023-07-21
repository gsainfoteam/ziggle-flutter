import 'dart:async';

import 'package:get/get.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';
import 'package:ziggle/app/data/provider/fcm.dart';
import 'package:ziggle/app/data/services/token/repository.dart';
import 'package:ziggle/app/data/services/user/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();
  final UserRepository _repository;
  final TokenRepository _tokenRepository;
  final FcmProvider _fcmProvider;
  UserInfoResponse? _user;
  bool _skipLogin = false;
  final _controller = StreamController<UserInfoResponse?>.broadcast();
  final _waitFirst = Completer<void>();

  UserService(this._repository, this._tokenRepository, this._fcmProvider) {
    _controller.stream.listen((user) {
      _user = user;
      Get.offAllNamed(
        (user == null && !_skipLogin) ? Routes.LOGIN : Routes.ROOT,
      );
    });
    _tokenRepository.getToken().listen((event) {
      _updateUser();
    });
    _fcmProvider.getFcmToken().listen((event) async {
      if (event == null) return;

      await getUserInfo().firstWhere((user) => user != null);
      await _repository.updateFcmToken(event);
    });
  }

  Future<void> loginWithCode(String code) async {
    final token = await _repository.loginWithCode(code);
    await _tokenRepository.saveToken(token);
  }

  Future<void> logout() async {
    _skipLogin = false;
    await _tokenRepository.deleteToken();
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

    return await _repository.userInfo();
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
