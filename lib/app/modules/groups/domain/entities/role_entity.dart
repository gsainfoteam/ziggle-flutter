import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_role_permission.dart';

class RoleEntity {
  final int id;
  final GroupMemberRole name;
  final String groupUuid;
  final List<GroupRolePermission> permissions;

  RoleEntity({
    required this.id,
    required this.name,
    required this.groupUuid,
    required this.permissions,
  });
}
