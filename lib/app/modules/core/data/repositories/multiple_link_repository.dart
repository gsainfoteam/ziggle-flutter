import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/data/repositories/fcm_repository.dart';

import '../../domain/repositories/link_repository.dart';

@LazySingleton(as: LinkRepository)
class MultipleLinkRepository implements LinkRepository {
  final FcmRepository _fcmRepository;

  MultipleLinkRepository(this._fcmRepository);

  @override
  Stream<String> getLinkStream() => MergeStream([
        _fcmRepository.getLinkStream(),
      ]);
}
