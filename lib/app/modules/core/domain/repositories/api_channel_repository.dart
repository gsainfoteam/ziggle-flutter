import '../enums/api_channel.dart';

abstract class ApiChannelRepository {
  void dispose();
  String get baseUrl;
  Stream<ApiChannel> get channel;
  void setChannel(ApiChannel channel);
  ApiChannel toggleChannel();
}
