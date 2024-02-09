import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/link_repository.dart';
import 'fcm_repository.dart';
import 'uni_links_link_repository.dart';

@LazySingleton(as: LinkRepository)
class MultipleLinkRepository implements LinkRepository {
  final FcmRepository _fcmRepository;
  final UniLinksLinkRepository _uniLinkLinkRepository;

  MultipleLinkRepository(this._fcmRepository, this._uniLinkLinkRepository);

  @override
  Stream<String> getLinkStream() => MergeStream([
        _fcmRepository.getLinkStream(),
        _uniLinkLinkRepository.getLinkStream(),
      ]);
}
