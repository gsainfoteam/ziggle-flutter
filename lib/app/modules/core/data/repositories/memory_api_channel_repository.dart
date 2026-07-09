import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';
import '../../domain/repositories/api_channel_repository.dart';

@Singleton(
  as: ApiChannelRepository,
  dispose: MemoryApiChannelRepository.dispose,
)
class MemoryApiChannelRepository implements ApiChannelRepository {
  final _subject = BehaviorSubject<ApiChannel>.seeded(ApiChannel.byMode());
  late final StreamSubscription<ApiChannel> _localSubscription;
  final ZiggleDio _ziggleDio;

  MemoryApiChannelRepository(this._ziggleDio) {
    _localSubscription = _subject.listen((value) {
      _ziggleDio.options.baseUrl = value.ziggleBaseUrl;
    });
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
  String get ziggleBaseUrl => _subject.value.ziggleBaseUrl;

  @override
  Stream<ApiChannel> get channel => _subject.stream;
}
