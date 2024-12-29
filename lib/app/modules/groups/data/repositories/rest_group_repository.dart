import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_invite_code_request_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/modify_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/group_api.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/notion_api.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

@Singleton(as: GroupRepository)
class RestGroupRepository implements GroupRepository {
  final GroupApi _api;
  final NotionApi _notionApi;
  final BehaviorSubject<GroupListEntity> _groupsSubject =
      BehaviorSubject.seeded(GroupListEntity(list: []));

  RestGroupRepository(this._api, this._notionApi);

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
    final GroupListModel fetched = await _api.getGroups();
    return fetched;
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
  Future<void> modifyName({required String uuid, required String name}) async {
    await _api.modifyGroup(uuid, ModifyGroupModel(name: name));
    await _refreshGroups();
  }

  @override
  Future<void> modifyDescription(
      {required String uuid, required String? description}) async {
    await _api.modifyGroup(uuid, ModifyGroupModel(description: description));
  }

  @override
  Future<void> modifyNotionLink(
      {required String uuid, required String? notionPageId}) async {
    await _api.modifyGroup(uuid, ModifyGroupModel(notionPageId: notionPageId));
  }

  @override
  Future<void> deleteGroup(String uuid) async {
    await _api.deleteGroup(uuid);
    await _refreshGroups();
  }

  @override
  Future<String> createInviteLink(
      {required String uuid, required int duration}) async {
    final response = await _api.createInviteCode(uuid, duration);
    return response.code;
  }

  @override
  Future<MemberListEntity> getMembers(String uuid) {
    // TODO: implement getMembers
    throw UnimplementedError();
  }

  @override
  Future<void> grantRoleToUser(
      {required String uuid, required String targetUuid, required int roleId}) {
    // TODO: implement grantRoleToUser
    throw UnimplementedError();
  }

  @override
  Future<void> leaveGroup(String uuid) {
    // TODO: implement leaveGroup
    throw UnimplementedError();
  }

  @override
  Future<void> removeMember(
      {required String uuid, required String targetUuid}) {
    // TODO: implement removeMember
    throw UnimplementedError();
  }

  @override
  Future<void> removeRoleFromUser(
      {required String uuid, required String targetUuid, required int roleId}) {
    // TODO: implement removeRoleFromUser
    throw UnimplementedError();
  }
}
