import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';

class RoleEntity {
  final int id;
  final GroupMemberRole name;
  final String groupUuid;
  final List<String> authorities;

  RoleEntity({
    required this.id,
    required this.name,
    required this.groupUuid,
    required this.authorities,
  });
}
