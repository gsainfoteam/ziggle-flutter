abstract class TokenRepository {
  Stream<String?> get token;
  Stream<String?> get refreshToken;
  DateTime? get tokenExpiration;
  DateTime? get refreshTokenExpiration;
  Future<void> saveToken(String token, {Duration duration});
  Future<void> saveRefreshToken(String token, {Duration duration});
  Future<void> deleteToken();
}
