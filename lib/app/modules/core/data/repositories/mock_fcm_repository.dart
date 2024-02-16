import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/repositories/fcm_repository.dart';

@Singleton(as: FcmRepository)
@test
class MockFcmRepository implements FcmRepository {
  @override
  Future<void> clearToken() async {}

  @override
  Stream<String> getLinkStream() => const Stream.empty();

  @override
  Stream<String> getTokenStream() => const Stream.empty();

  @override
  @PostConstruct(preResolve: true)
  Future<void> init() async {}
}
