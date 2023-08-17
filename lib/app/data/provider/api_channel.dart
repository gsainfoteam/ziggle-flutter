import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/api_channel.dart';

class ApiChannelProvider {
  static ApiChannelProvider get to => Get.find();

  ApiChannel get channel => _channel;
  late ApiChannel _channel;

  ApiChannelProvider() {
    setChannel(ApiChannel.byMode);
  }

  void setChannel(ApiChannel channel) {
    _channel = channel;
    Get.find<Dio>().options.baseUrl = channel.baseUrl;
  }

  ApiChannel toggleChannel() {
    setChannel(channel.oppose);
    return channel;
  }
}
