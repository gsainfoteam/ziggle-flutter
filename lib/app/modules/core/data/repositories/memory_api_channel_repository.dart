import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/core/domain/enums/groups_api_channel.dart';
import 'package:ziggle/app/modules/core/domain/enums/ziggle_api_channel.dart';

import '../../domain/repositories/api_channel_repository.dart';

@Singleton(
  as: ApiChannelRepository,
  dispose: MemoryApiChannelRepository.dispose,
)
class MemoryApiChannelRepository implements ApiChannelRepository {
  final _ziggleSubject =
      BehaviorSubject<ZiggleApiChannel>.seeded(ZiggleApiChannel.byMode());
  final _groupsSubject =
      BehaviorSubject<GroupsApiChannel>.seeded(GroupsApiChannel.byMode());
  late final StreamSubscription<ZiggleApiChannel> _localZiggleSubscription;
  late final StreamSubscription<GroupsApiChannel> _localGroupsSubscription;
  final ZiggleDio _ziggleDio;
  final GroupsDio _groupsDio;

  MemoryApiChannelRepository(this._ziggleDio, this._groupsDio) {
    _localZiggleSubscription = _ziggleSubject.listen(
      (value) => _ziggleDio.options.baseUrl = value.baseUrl,
    );
    _localGroupsSubscription = _groupsSubject.listen(
      (value) => _groupsDio.options.baseUrl = value.baseUrl,
    );
  }

  static FutureOr dispose(ApiChannelRepository repository) {
    final repo = repository as MemoryApiChannelRepository;
    repo._localZiggleSubscription.cancel();
    repo._localGroupsSubscription.cancel();
    repo._ziggleSubject.close();
    repo._groupsSubject.close();
  }

  // @override
  // void setChannel(ApiChannel channel) {
  //   _subject.add(channel);
  // }

  @override
  ZiggleApiChannel toggleZiggleChannel() {
    final ziggleChannel = _ziggleSubject.value.oppose;
    _ziggleSubject.add(ziggleChannel);
    return ziggleChannel;
  }

  @override
  GroupsApiChannel toggleGroupsChannel() {
    final groupsChannel = _groupsSubject.value.oppose;
    _groupsSubject.add(groupsChannel);
    return groupsChannel;
  }

  // @override
  // String get baseUrl => _subject.value.baseUrl;

  @override
  Stream<ZiggleApiChannel> get ziggleChannel => _ziggleSubject.stream;

  @override
  Stream<GroupsApiChannel> get groupsChannel => _groupsSubject.stream;
}
