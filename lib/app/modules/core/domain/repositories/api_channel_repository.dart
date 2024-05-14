import '../enums/api_channel.dart';

abstract class ApiChannelRepository {
  void dispose();
  String get baseUrl;
  String get idpUrl;
  String get idpClientId;
  Stream<ApiChannel> get channel;
  void setChannel(ApiChannel channel);
  ApiChannel toggleChannel();
}
