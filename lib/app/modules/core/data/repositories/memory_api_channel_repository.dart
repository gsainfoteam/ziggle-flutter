import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/enums/api_channel.dart';
import '../../domain/repositories/api_channel_repository.dart';

@Singleton(
  as: ApiChannelRepository,
  dispose: MemoryApiChannelRepository.dispose,
)
class MemoryApiChannelRepository implements ApiChannelRepository {
  final _subject =
      BehaviorSubject<ApiChannel>.seeded(ApiChannel.ziggleByMode());
  late final StreamSubscription<ApiChannel> _localSubscription;
  final Dio _ziggleDio;
  final Dio _groupsDio;

  MemoryApiChannelRepository(
    @Named('ziggleDio') this._ziggleDio,
    @Named('groupsDio') this._groupsDio,
  ) {
    _localSubscription = _subject.listen(
      (value) {
        if (value == ApiChannel.ziggleStaging ||
            value == ApiChannel.ziggleProduction) {
          _ziggleDio.options.baseUrl = value.baseUrl;
        } else {
          _groupsDio.options.baseUrl = value.baseUrl;
        }
      },
    );
  }

  static FutureOr dispose(ApiChannelRepository repository) {
    final repo = repository as MemoryApiChannelRepository;
    repo._localSubscription.cancel();
    repo._subject.close();
  }

  @override
  void setChannel(ApiChannel channel) {
    _subject.add(channel);
  }

  @override
  ApiChannel toggleChannel() {
    final channel = _subject.value.oppose;
    _subject.add(channel);
    return channel;
  }

  @override
  String get baseUrl => _subject.value.baseUrl;

  @override
  Stream<ApiChannel> get channel => _subject.stream;
}
