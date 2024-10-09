import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';

import '../../domain/enums/api_channel.dart';
import '../../domain/repositories/api_channel_repository.dart';

@Singleton(
  as: ApiChannelRepository,
  dispose: MemoryApiChannelRepository.dispose,
)
class MemoryApiChannelRepository implements ApiChannelRepository {
  final _ziggleSubject =
      BehaviorSubject<ApiChannel>.seeded(ApiChannel.ziggleByMode());
  final _groupsSubject =
      BehaviorSubject<ApiChannel>.seeded(ApiChannel.groupsBymode());
  late final StreamSubscription<ApiChannel> _localZiggleSubscription;
  late final StreamSubscription<ApiChannel> _localGroupsSubscription;
  final ZiggleDio _ziggleDio;
  final GroupsDio _groupsDio;

  MemoryApiChannelRepository(
    this._ziggleDio,
    this._groupsDio,
  ) {
    _localZiggleSubscription = _ziggleSubject
        .listen((value) => _ziggleDio.options.baseUrl = value.baseUrl);
    _localGroupsSubscription = _groupsSubject
        .listen((value) => _groupsDio.options.baseUrl = value.baseUrl);
  }

  static FutureOr dispose(ApiChannelRepository repository) {
    final repo = repository as MemoryApiChannelRepository;
    repo._localZiggleSubscription.cancel();
    repo._localGroupsSubscription.cancel();
    repo._ziggleSubject.close();
    repo._groupsSubject.close();
  }

//   @override
//   void setChannel(ApiChannel channel) {
//     if (channel == ApiChannel.groupsProduction ||
//         channel == ApiChannel.groupsStaging) {
//       _groupsSubject.add(channel);
//     }
//     else if (channel == ApiChannel.ziggleProduction || channel = ApiChannel.ziggleStaging){
// _ziggleSubject.add(channel);
//     }
//   }

  @override
  ApiChannel toggleChannel() {
    final channel = _subject.value.oppose;
    _subject.add(channel);
    return channel;
  }

//   @override
//   String get baseUrl => _subject.value.baseUrl;

//   @override
//   Stream<ApiChannel> get channel => _subject.stream;
}
