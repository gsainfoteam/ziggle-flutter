abstract class AuthRepository {
  Future<void> login();
  Stream<bool> get isSignedIn;
  Future<void> logout();
}
