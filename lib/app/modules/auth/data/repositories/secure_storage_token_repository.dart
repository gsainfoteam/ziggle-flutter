import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/repositories/flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@Singleton(
  as: TokenRepository,
  dispose: FlutterSecureStorageTokenRepository.dispose,
)
class SecureStorageTokenRepository extends FlutterSecureStorageTokenRepository {
  SecureStorageTokenRepository(FlutterSecureStorage storage)
    : super(
        storage: storage,
        tokenKey: '_ziggle_token',
        expiredAtKey: '_ziggle_expiredAt',
      );

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await super.init();
  }
}
