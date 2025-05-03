abstract class OAuthRepository {
  Future<String> getToken();
  Future<void> setRecentLogout([bool value = true]);
}
