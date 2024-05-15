import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/enums/api_channel.dart';
import '../../domain/repositories/api_channel_repository.dart';

@Singleton(as: ApiChannelRepository)
class MemoryApiChannelRepository implements ApiChannelRepository {
  final _subject = BehaviorSubject<ApiChannel>.seeded(ApiChannel.byMode());
  late final StreamSubscription<ApiChannel> _localSubscription;
  final Dio _dio;

  MemoryApiChannelRepository(this._dio) {
    _localSubscription = _subject.listen(
      (value) => _dio.options.baseUrl = value.baseUrl,
    );
  }

  @override
  @disposeMethod
  void dispose() {
    _localSubscription.cancel();
    _subject.close();
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
  String get idpUrl => _subject.value.idpBaseUrl;

  @override
  Stream<ApiChannel> get channel => _subject.stream;

  @override
  String get idpClientId => _subject.value.idpClientId;
}
