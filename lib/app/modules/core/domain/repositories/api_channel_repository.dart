import '../enums/api_channel.dart';

abstract class ApiChannelRepository {
  String get baseUrl;
  Stream<ApiChannel> get channel;
  void setChannel(ApiChannel channel);
  ApiChannel toggleChannel();
}
