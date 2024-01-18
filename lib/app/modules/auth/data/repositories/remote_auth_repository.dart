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
      if (token == null) return _userController.add(null);
      _userController.add(await _api.info());
    });
  }

  @override
  Future<UserEntity> login(String code) async {
    final token = await _api.login(code);
    await _tokenRepository.saveToken(token.accessToken);
    final user = await _api.info();
    _userController.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _api.logout();
    await _tokenRepository.deleteToken();
    _userController.add(null);
  }

  @override
  Stream<UserEntity?> get user async* {
    try {
      final user = await _api.info();
      yield user;
    } catch (_) {
      yield null;
    }
    yield* _userController.stream;
  }
}
