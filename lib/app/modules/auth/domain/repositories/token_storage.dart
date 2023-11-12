abstract class TokenStorage {
  Future<void> save(String token);
  Stream<String?> read();
  Future<void> delete();
  Future<bool> hasToken();
}
