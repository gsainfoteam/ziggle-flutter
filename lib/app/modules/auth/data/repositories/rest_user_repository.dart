import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

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

  RestUserRepository(this._api, this._authRepository, this._tokenRepository);

  @override
  Future<UserEntity?> userInfo() async {
    try {
      return _api.userInfo();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity> login() async {
    final auth = await _authRepository.login();
    try {
      final token = await _api.login(auth.authCode);
      _tokenRepository.save(token.accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongAuthCodeException();
      }
      rethrow;
    }
    return _api.userInfo();
  }
}
