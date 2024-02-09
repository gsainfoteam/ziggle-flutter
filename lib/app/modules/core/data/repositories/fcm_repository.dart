import 'package:injectable/injectable.dart';

import '../../domain/repositories/link_repository.dart';
import '../../domain/repositories/push_message_repository.dart';

@Singleton(as: PushMessageRepository)
class FcmRepository implements PushMessageRepository, LinkRepository {
  @override
  Stream<String> getTokenStream() {
    throw UnimplementedError();
  }

  @override
  Stream<String> getLinkStream() {
    throw UnimplementedError();
  }
}
