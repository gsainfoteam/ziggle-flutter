import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/repositories/flutter_secure_storage_token_repository.dart';

@named
@Singleton(as: FlutterSecureStorageTokenRepository)
class ZiggleFlutterSecureStorageTokenRepository
    extends FlutterSecureStorageTokenRepository {
  ZiggleFlutterSecureStorageTokenRepository(FlutterSecureStorage storage)
      : super(
          storage: storage,
          tokenKey: '_ziggle_token',
          expiredAtKey: '_ziggle_expiredAt',
        );
}
