abstract class PushMessageRepository {
  Stream<String> getTokenStream();
  Future<void> clearToken();
}
