import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/link_repository.dart';
import 'fcm_repository.dart';

@LazySingleton(as: LinkRepository)
class MultipleLinkRepository implements LinkRepository {
  final FcmRepository _fcmRepository;

  MultipleLinkRepository(this._fcmRepository);

  @override
  Stream<String> getLinkStream() => MergeStream([
        _fcmRepository.getLinkStream(),
      ]);
}
