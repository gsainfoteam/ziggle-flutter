import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/messaging_repository.dart';

import '../../data/data_sources/remote/user_api.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/token_repository.dart';
import '../../domain/repositories/user_repository.dart';

class WrongAuthCodeException implements Exception {}

@Injectable(as: UserRepository)
class RestUserRepository implements UserRepository {
  final UserApi _api;
  final AuthRepository _authRepository;
  final TokenRepository _tokenRepository;
  final MessagingRepository _messagingRepository;
  final _controller = StreamController<UserEntity?>.broadcast();

  RestUserRepository(this._api, this._authRepository, this._tokenRepository,
      this._messagingRepository) {
    _messagingRepository.getToken().listen((token) {
      if (token != null) {
        _api.updateFcmToken(token);
      }
    });
    _tokenRepository.read().listen((event) => _updateUser());
  }

  Future<UserEntity?> _updateUser() async {
    try {
      final user = await _api.userInfo();
      _controller.add(user);
      return user;
    } catch (_) {
      _controller.add(null);
      return null;
    }
  }

  @override
  Stream<UserEntity?> userInfo() async* {
    yield await _updateUser();
    yield* _controller.stream;
  }

  @override
  Future<UserEntity> login() async {
    final auth = await _authRepository.login();
    try {
      final token = await _api.login(auth.authCode);
      await _tokenRepository.save(token.accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongAuthCodeException();
      }
      rethrow;
    }
    return _api.userInfo();
  }
}
