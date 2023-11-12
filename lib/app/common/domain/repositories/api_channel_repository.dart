import 'package:ziggle/app/common/domain/enums/api_channel.dart';

abstract class ApiChannelRepository {
  String get baseUrl;
  String get idpUrl;
  Stream<ApiChannel> get channel;
  void setChannel(ApiChannel channel);
  ApiChannel toggleChannel();
}
