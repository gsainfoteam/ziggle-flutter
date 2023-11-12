import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> userInfo();
  Future<UserEntity> login();
}
