import 'dart:io';

import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/domain/entities/authority_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/role_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/role_list_entity.dart';

abstract class GroupRepository {
  Future<GroupListEntity> getGroups();
  Stream<GroupListEntity> watchGroups();
  Future<GroupEntity> createGroup({
    required String name,
    File? image,
    required String description,
    String? notionPageId,
  });
  Future<GroupEntity> getGroup(String uuid);
  Future<void> updateGroup({
    required String uuid,
    required String name,
    required String description,
    required String? notionPageId,
  });
  Future<void> deleteGroup(String uuid);
  Future<void> modifyProfileImage({required String uuid, required File image});
  Future<String> createInviteLink({
    required GroupEntity group,
    required GroupMemberRole role,
    required Duration durationDays,
  });
  Future<void> leaveGroup(String groupUuid);
  Future<MemberListEntity> getMembers(String uuid);
  Future<void> removeMember({required String uuid, required String targetUuid});
  Future<void> grantRoleToUser({
    required String uuid,
    required String targetUuid,
    required int roleId,
  });
  Future<void> removeRoleFromUser({
    required String uuid,
    required String targetUuid,
    required int roleId,
  });
  Future<RoleListEntity> getRoles(String groupUuid);
  Future<void> createRole(String groupUuid, RoleEntity role);
  Future<void> updateRole(
    String groupUuid,
    int roleId,
    AuthorityEntity authority,
  );
  Future<void> deleteRole(String groupUuid, int roleId);
  Future<bool> checkGroupExistence(String name);
  Future<RoleEntity> getUserRoleInGroup(String uuid);
}
