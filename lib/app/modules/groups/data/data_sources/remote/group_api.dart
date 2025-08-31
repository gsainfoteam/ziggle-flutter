import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_invite_code_response_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_item_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/member_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/modify_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/role_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/role_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/update_role_model.dart';

part 'group_api.g.dart';

@injectable
@RestApi(baseUrl: 'group/')
abstract class GroupApi {
  @factoryMethod
  factory GroupApi(GroupsDio dio) = _GroupApi;

  @POST('')
  Future<GroupItemModel> createGroup(@Body() CreateGroupModel model);

  @GET('')
  Future<GroupListModel> getGroups();

  @GET('{uuid}')
  Future<GroupModel> getGroup(
    @Path('uuid') String uuid,
  );

  @PATCH('{uuid}')
  Future<void> modifyGroup(
    @Path('uuid') String uuid,
    @Body() ModifyGroupModel model,
  );

  @DELETE('{uuid}')
  Future<void> deleteGroup(
    @Path('uuid') String uuid,
  );

  @GET('{name}/exist')
  Future<String> checkGroupExistence(@Path('name') String name);

  @POST('{uuid}/image')
  @MultiPart()
  Future<void> uploadImage(
    @Path('uuid') String uuid,
    @Part(name: 'file') File image,
  );

  @GET('{uuid}/role')
  Future<RoleModel> getUserRoleInGroup(
    @Path('uuid') String uuid,
  );

  @POST('{uuid}/invite')
  Future<GroupInviteCodeResponseModel> createInviteCode(
    @Path('uuid') String uuid,
    @Query('roleId') int roleId,
    @Query('duration') int duration,
  );

  @GET('{uuid}/member')
  Future<MemberListModel> getMembers(
    @Path('uuid') String uuid,
  );

  @POST('join')
  Future<void> joinGroup(@Body() Map<String, String> code);

  @DELETE('{uuid}/member/{targetUuid}')
  Future<void> banishUser(
    @Path('uuid') String uuid,
    @Path('targetUuid') String targetUuid,
  );

  @PATCH('{uuid}/member/{targetUuid}/role')
  Future<void> grantUserRole(
    @Path('uuid') String uuid,
    @Path('targetUuid') String targetUuid,
    @Query('roleId') int roleId,
  );

  @DELETE('{uuid}/member/{targetUuid}/role')
  Future<void> deleteUserRole(
    @Path('uuid') String uuid,
    @Path('targetUuid') String targetUuid,
    @Query('roleId') int roleId,
  );

  @PATCH('{uuid}/visibility')
  Future<void> updateVisibility(
    @Path('uuid') String uuid,
    @Body() Map<String, String> visibility,
  );

  @PATCH('{uuid}/president')
  Future<void> updatePresident(
    @Path('uuid') String uuid,
    @Body() Map<String, String> newPresidentUuid,
  );

  @GET('{groupUuid}/role')
  Future<RoleListModel> getRoles(
    @Path('groupUuid') String groupUuid,
  );

  @POST('{groupUuid}/role')
  Future<void> createRole(
    @Path('groupUuid') String groupUuid,
    @Body() CreateGroupModel createGroupModel,
  );

  @PATCH('{groupUuid}/role/{id}')
  Future<void> updateRole(
    @Path('groupUuid') String groupUuid,
    @Path('id') String id,
    @Body() UpdateRoleModel updateRoleModel,
  );

  @DELETE('{groupUuid}/role/{id}')
  Future<void> deleteRole(
    @Path('groupUuid') String groupUuid,
    @Path('id') String id,
  );

  @DELETE('{groupUuid}/member/leave')
  Future<void> leaveGroup(@Path('groupUuid') String groupUuid);
}
