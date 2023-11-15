abstract class MessagingRepository {
  Stream<String?> getToken();
  Stream<String> getLink();
}
