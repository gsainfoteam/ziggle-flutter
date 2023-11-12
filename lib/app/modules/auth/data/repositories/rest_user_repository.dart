import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/user_repository.dart';

@Injectable(as: UserRepository)
class RestUserRepository implements UserRepository {
  final UserApi _api;

  RestUserRepository(this._api);

  @override
  Future<UserEntity?> userInfo() async {
    try {
      return _api.userInfo();
    } catch (_) {
      return null;
    }
  }
}
