import 'package:ziggle/app/modules/groups/domain/entities/group_user_entity.dart';

abstract class AuthRepository {
  Future<void> login();
  Stream<bool> get isSignedIn;
  Future<void> logout();
  Future<GroupUserEntity> info();
}
