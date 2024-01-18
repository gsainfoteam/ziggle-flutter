import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/token_repository.dart';
import '../data_source/remote/user_api.dart';

@Injectable(as: AuthRepository)
class RemoteAuthRepository implements AuthRepository {
  final UserApi _api;
  final TokenRepository _tokenRepository;

  RemoteAuthRepository(this._api, this._tokenRepository);

  @override
  Future<UserEntity> login(String code) async {
    final token = await _api.login(code);
    await _tokenRepository.saveToken(token.accessToken);
    final user = await _api.info();
    return user;
  }

  @override
  Future<void> logout() async {
    await _api.logout();
    await _tokenRepository.deleteToken();
  }
}
