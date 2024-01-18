abstract class TokenRepository {
  Future<bool> hasToken();
  Stream<String?> get token;
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}
