import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Stream<UserEntity?> userInfo();
  Future<UserEntity> login();
}
