import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';

class GroupListEntity {
  final int total;
  final List<GroupEntity> list;

  GroupListEntity({required this.total, required this.list});
}
