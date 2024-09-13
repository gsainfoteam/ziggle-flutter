abstract class TokenRepository {
  Stream<String?> get token;
  DateTime? get tokenExpiration;
  Future<void> saveToken(String token, {Duration? duration});
  Future<void> deleteToken();
}
