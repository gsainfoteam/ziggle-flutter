import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/token_repository.dart';
import '../data_source/remote/user_api.dart';

@Injectable(as: AuthRepository)
class RemoteAuthRepository implements AuthRepository {
  final UserApi _api;
  final TokenRepository _tokenRepository;
  final _userController = StreamController<UserEntity?>.broadcast();

  RemoteAuthRepository(this._api, this._tokenRepository) {
    _tokenRepository.token.listen((token) async {
      _userController.add(await _user);
    });
  }

  Future<UserEntity?> get _user async {
    try {
      if (await _tokenRepository.token.first == null) {
        return null;
      } else {
        return await _api.info();
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity> login(String code) async {
    final token = await _api.login(code);
    await _tokenRepository.saveToken(token.accessToken, token.expiresIn);
    final user = await _api.info();
    _userController.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    final accessToken = await _tokenRepository.token.first;
    if (accessToken == null) return;
    await _api.logout(accessToken);
    await _tokenRepository.deleteToken();
    _userController.add(null);
  }

  @override
  Stream<UserEntity?> get user async* {
    yield await _user;
    yield* _userController.stream;
  }

  @override
  Future<void> updatePushToken(String token) {
    return _api.updateFcmToken(token);
  }
}
