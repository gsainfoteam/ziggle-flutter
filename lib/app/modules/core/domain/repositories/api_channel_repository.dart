import 'package:ziggle/app/modules/core/domain/enums/groups_api_channel.dart';
import 'package:ziggle/app/modules/core/domain/enums/ziggle_api_channel.dart';

abstract class ApiChannelRepository {
  //void setChannel(ApiChannel channel);
  ZiggleApiChannel toggleZiggleChannel();
  GroupsApiChannel toggleGroupsChannel();
  // String get baseUrl;
  Stream<ZiggleApiChannel> get ziggleChannel;
  Stream<GroupsApiChannel> get groupsChannel;
}
