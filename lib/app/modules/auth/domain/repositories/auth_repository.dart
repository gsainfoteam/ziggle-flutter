import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String code);
  Future<void> logout();
  Stream<UserEntity?> get user;
  Future<void> updatePushToken(String token);
}
