import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/repositories/flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@named
@Singleton(as: TokenRepository)
class ZiggleFlutterSecureStorageTokenRepository
    extends FlutterSecureStorageTokenRepository {
  ZiggleFlutterSecureStorageTokenRepository(FlutterSecureStorage storage)
      : super(
          storage: storage,
          tokenKey: '_ziggle_token',
          expiredAtKey: '_ziggle_expiredAt',
          refreshTokenKey: '_ziggle_refreshToken',
          refreshTokenExpiredAtKey: '_ziggle_refreshTokenExpiredAt',
        );

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await super.init();
  }
}
