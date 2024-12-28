import 'dart:developer';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/modify_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/group_api.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/notion_api.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

@Injectable(as: GroupRepository)
class RestGroupRepository implements GroupRepository {
  final GroupApi _api;
  final NotionApi _notionApi;

  final BehaviorSubject<GroupListEntity> _groupsSubject =
      BehaviorSubject.seeded(GroupListEntity(groups: []));

  RestGroupRepository(
    this._api,
    this._notionApi,
  );

  @override
  Future<GroupModel> createGroup({
    required String name,
    File? image,
    required String description,
    String? notionPageId,
  }) async {
    final createdGroup = await _api.createGroup(CreateGroupModel(
      name: name,
      description: description,
      notionPageId: notionPageId,
    ));

    if (image != null) await _api.uploadImage(createdGroup.uuid, image);
    return createdGroup;
  }

  @override
  Stream<GroupListEntity> watchGroups() => _groupsSubject.stream;

  @override
  Future<GroupListEntity> getGroups() async {
    final GroupListModel fetched = await _api.getGroups();
    _groupsSubject.add(fetched);
    return fetched;
  }

  @override
  Future<GroupEntity> getGroup(String uuid) {
    return _api.getGroup(uuid);
  }

  @override
  Future<void> modifyName({required String uuid, required String name}) async {
    await _api.modifyGroup(uuid, ModifyGroupModel(name: name));
  }

  @override
  Future<void> modifyDescription(
      {required String uuid, required String? description}) async {
    print(ModifyGroupModel(description: description));
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
  }

  @override
  Future<String> createInviteLink(
      {required String uuid, required int duration}) {
    // TODO: implement createInviteLink
    throw UnimplementedError();
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

  Future<void> _refreshGroups() async {
    try {
      final newList = await getGroups();
      // 위 getGroups()가 끝나면 _groupsSubject에 add까지 이미 해둠
      log('Groups refreshed: ${newList.groups.length} items found');
    } catch (e, st) {
      // 실제 프로젝트에선 예외처리/에러 로깅
      log('Failed to refresh groups: $e', stackTrace: st);
      rethrow;
    }
  }
}
