import '../entities/oauth_entity.dart';

abstract class OAuthRepository {
  Future<OAuthEntity> getAuthorizationCode();
  Future<void> setRecentLogout([bool value = true]);
}
