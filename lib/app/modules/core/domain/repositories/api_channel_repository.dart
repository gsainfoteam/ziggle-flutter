import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';

abstract class ApiChannelRepository {
  void setChannel(ApiChannel channel);
  ApiChannel toggleChannel();
  String get ziggleBaseUrl;
  String get groupsBaseUrl;
  Stream<ApiChannel> get channel;
}
