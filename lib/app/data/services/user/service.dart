import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';
import 'package:ziggle/app/data/services/token/repository.dart';
import 'package:ziggle/app/data/services/user/repository.dart';
import 'package:ziggle/app/routes/pages.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();
  final UserRepository _repository;
  final TokenRepository _tokenRepository;
  UserInfoResponse? _user;
  final _controller = StreamController<UserInfoResponse?>.broadcast();
  final _waitFirst = Completer<void>();

  UserService(this._repository, this._tokenRepository) {
    _controller.stream.listen((user) {
      _user = user;
      Get.offAllNamed(user == null ? Routes.LOGIN : Routes.ROOT);
    });
    _tokenRepository.getToken().listen((event) {
      _updateUser();
    });
  }

  Future<void> loginWithCode(String code) async {
    final token = await _repository.loginWithCode(code);
    await _tokenRepository.saveToken(token);
  }

  Future<void> logout() async {
    await _tokenRepository.deleteToken();
  }

  Future<UserInfoResponse?> _updateUser() async {
    final user = await _fetchUserInfo();
    _controller.add(user);
    if (!_waitFirst.isCompleted) _waitFirst.complete();
    return user;
  }

  Future<UserInfoResponse?> _fetchUserInfo() async {
    final token = await _tokenRepository.getToken().first;
    if (token == null) {
      return null;
    }
    final bodyBase64 = token.split('.')[1];
    final width = (bodyBase64.length / 4).ceil() * 4;
    final paddedBodyBase64 = bodyBase64.padRight(width, '=');
    final bodyJson = utf8.fuse(base64Url).decode(paddedBodyBase64);
    final body = jsonDecode(bodyJson);
    final userUuid = body['userUUID'];

    return await _repository.userInfo(userUuid);
  }

  Stream<UserInfoResponse?> getUserInfo() async* {
    await _waitFirst.future;
    yield _user;
    yield* _controller.stream;
  }
}
