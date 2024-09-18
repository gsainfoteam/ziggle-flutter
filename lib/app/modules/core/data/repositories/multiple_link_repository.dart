import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/data/repositories/fcm_messaging_repository.dart';
import 'package:ziggle/app/modules/core/data/repositories/uni_links_link_repository.dart';
import 'package:ziggle/app/modules/core/domain/repositories/link_repository.dart';

@LazySingleton(as: LinkRepository)
class MultipleLinkRepository implements LinkRepository {
  final FcmMessagingRepository _fcmRepository;
  final UniLinksLinkRepository _uniLinkLinkRepository;

  MultipleLinkRepository(this._fcmRepository, this._uniLinkLinkRepository);

  @override
  Stream<String> getLinkStream() => MergeStream([
        _fcmRepository.getLinkStream(),
        _uniLinkLinkRepository.getLinkStream(),
      ]);
}
