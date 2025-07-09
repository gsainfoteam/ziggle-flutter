import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/modify_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/group_api.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/domain/entities/authority_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/role_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/role_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';
import 'package:ziggle/app/values/strings.dart';

@Singleton(as: GroupRepository)
class RestGroupRepository implements GroupRepository {
  final GroupApi _api;
  final BehaviorSubject<GroupListEntity> _groupsSubject =
      BehaviorSubject.seeded(GroupListEntity(list: []));

  RestGroupRepository(this._api);

  @override
  Future<GroupEntity> createGroup({
    required String name,
    File? image,
    required String description,
    String? notionPageId,
  }) async {
    final createdGroup = await _api.createGroup(CreateGroupModel(
        name: name, description: description, notionPageId: notionPageId));
    if (image != null) await _api.uploadImage(createdGroup.uuid, image);
    await _refreshGroups();
    return createdGroup;
  }

  Future<void> _refreshGroups() async {
    final newList = await _api.getGroups();
    _groupsSubject.add(newList);
  }

  @override
  Stream<GroupListEntity> watchGroups() => _groupsSubject.stream;

  @override
  Future<GroupListEntity> getGroups() async {
    final GroupListModel groups = await _api.getGroups();
    _groupsSubject.add(groups);
    return groups;
  }

  @override
  Future<GroupEntity> getGroup(String uuid) {
    return _api.getGroup(uuid);
  }

  @override
  Future<void> modifyProfileImage({required String uuid, required File image}) {
    return _api.uploadImage(uuid, image);
  }

  @override
  Future<void> modifyGroup({
    required String uuid,
    required String name,
    required String description,
    required String? notionPageId,
  }) async {
    await _api.modifyGroup(
        uuid,
        ModifyGroupModel(
            name: name, description: description, notionPageId: notionPageId));
    await _refreshGroups();
  }

  @override
  Future<void> deleteGroup(String uuid) async {
    await _api.deleteGroup(uuid);
    await _refreshGroups();
  }

  @override
  Future<String> createInviteLink({
    required GroupEntity group,
    required GroupMemberRole role,
    required Duration durationDays,
  }) async {
    final response = await _api.createInviteCode(
        group.uuid, role.toInt(), durationDays.inDays);
    final inviteLink =
        "${Strings.groupsBaseUrl}/invite/${response.code}/${group.uuid}";
    return inviteLink;
  }

  @override
  Future<MemberListEntity> getMembers(String uuid) async {
    return _api.getMembers(uuid);
  }

  @override
  Future<RoleEntity> getUserRoleInGroup(String uuid) {
    return _api.getUserRoleInGroup(uuid);
  }

  @override
  Future<void> grantRoleToUser(
      {required String uuid, required String targetUuid, required int roleId}) {
    return _api.grantUserRole(uuid, targetUuid, roleId);
  }

  @override
  Future<void> leaveGroup(String groupUuid) async {
    await _api.leaveGroup(groupUuid);
  }

  @override
  Future<void> removeMember(
      {required String uuid, required String targetUuid}) async {
    await _api.banishUser(uuid, targetUuid);
    await _refreshGroups();
  }

  @override
  Future<void> removeRoleFromUser(
      {required String uuid, required String targetUuid, required int roleId}) {
    return _api.deleteUserRole(uuid, targetUuid, roleId);
  }

  @override
  Future<void> createRole(String groupUuid, RoleEntity role) {
    // TODO: implement createRole
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRole(String groupUuid, int roleId) {
    // TODO: implement deleteRole
    throw UnimplementedError();
  }

  @override
  Future<RoleListEntity> getRoles(String groupUuid) {
    return _api.getRoles(groupUuid);
  }

  @override
  Future<void> updateRole(
      String groupUuid, int roleId, AuthorityEntity authority) {
    // TODO: implement updateRole
    throw UnimplementedError();
  }
}
