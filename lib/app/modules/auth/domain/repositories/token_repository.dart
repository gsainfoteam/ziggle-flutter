abstract class TokenRepository {
  Future<bool> hasExpired();
  Future<bool> hasToken();
  Stream<String?> get token;
  Future<void> saveToken(String token, int expiresIn);
  Future<void> deleteToken();
}
