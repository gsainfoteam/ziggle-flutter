import 'dart:io';

import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';

abstract class GroupRepository {
  Future<GroupEntity> createGroup({
    required String name,
    File? image,
    required String description,
    String? notionPageId,
  });

  Stream<GroupListEntity> watchGroups();
  Future<GroupListEntity> getGroups();

  Future<GroupEntity> getGroup(String uuid);

  Future<void> modifyProfileImage({
    required String uuid,
    required File image,
  });
  Future<void> modifyName({
    required String uuid,
    required String name,
  });
  Future<void> modifyDescription({
    required String uuid,
    required String? description,
  });
  Future<void> modifyNotionLink({
    required String uuid,
    required String? notionPageId,
  });

  Future<String> createInviteLink(
      {required String uuid, required int duration});

  Future<MemberListEntity> getMembers(String uuid);
  Future<void> removeMember({
    required String uuid,
    required String targetUuid,
  });
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

  Future<void> deleteGroup(String uuid);
  Future<void> leaveGroup(String uuid);
}
