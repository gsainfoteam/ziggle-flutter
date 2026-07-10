import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';

abstract class ApiChannelRepository {
  void setChannel(ApiChannel channel);
  ApiChannel toggleChannel();
  String get ziggleBaseUrl;
  Stream<ApiChannel> get channel;
}
