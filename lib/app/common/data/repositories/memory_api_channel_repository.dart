import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/api_channel_repository.dart';

import '../../domain/enums/api_channel.dart';

@Singleton(as: ApiChannelRepository)
class MemoryApiChannelRepository implements ApiChannelRepository {
  ApiChannel _channel = ApiChannel.byMode();
  final _controller = StreamController<ApiChannel>.broadcast();
  final Dio _dio;

  MemoryApiChannelRepository(this._dio) {
    _dio.options.baseUrl = _channel.baseUrl;
  }

  @override
  void setChannel(ApiChannel channel) {
    _channel = channel;
    _dio.options.baseUrl = channel.baseUrl;
  }

  @override
  ApiChannel toggleChannel() {
    setChannel(_channel.oppose);
    return _channel;
  }

  @override
  String get baseUrl => _channel.baseUrl;

  @override
  String get idpUrl => _channel.idpBaseUrl;

  @override
  Stream<ApiChannel> get channel async* {
    yield _channel;
    yield* _controller.stream;
  }
}
