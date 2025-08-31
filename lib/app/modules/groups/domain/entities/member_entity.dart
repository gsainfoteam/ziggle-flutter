import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';

class MemberEntity {
  final String uuid;
  final String name;
  final String? email;
  final GroupMemberRole? role;

  MemberEntity({
    required this.uuid,
    required this.name,
    this.email,
    this.role,
  });
}
