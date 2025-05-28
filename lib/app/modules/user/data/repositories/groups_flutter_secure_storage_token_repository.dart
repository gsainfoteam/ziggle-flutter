import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/repositories/flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@named
@Singleton(as: TokenRepository)
class GroupsFlutterSecureStorageTokenRepository
    extends FlutterSecureStorageTokenRepository {
  GroupsFlutterSecureStorageTokenRepository(FlutterSecureStorage storage)
      : super(
          storage: storage,
          tokenKey: '_groups_token',
          expiredAtKey: '_groups_expiredAt',
          refreshTokenKey: '_groups_refreshToken',
          refreshTokenExpiredAtKey: '_groups_refreshTokenExpiredAt',
        );

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await super.init();
  }
}
