import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/repositories/flutter_secure_storage_token_repository.dart';

@named
@Singleton(as: FlutterSecureStorageTokenRepository)
class GroupsFlutterSecureStorageTokenRepository
    extends FlutterSecureStorageTokenRepository {
  GroupsFlutterSecureStorageTokenRepository(FlutterSecureStorage storage)
      : super(
          storage: storage,
          tokenKey: '_groups_token',
          expiredAtKey: '_groups_expiredAt',
        );
}
