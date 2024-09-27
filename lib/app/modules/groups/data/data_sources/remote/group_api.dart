import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/modify_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/role_list_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/update_role_model.dart';

part 'group_api.g.dart';

@injectable
@RestApi(baseUrl: 'group/')
abstract class GroupApi {
  @factoryMethod
  factory GroupApi(Dio dio) = _GroupApi;

  @GET('')
  Future<GroupListModel> getGroups();

  @POST('')
  Future<GroupModel> createGroup(@Body() CreateGroupModel model);

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
  Future<void> uploadImage(
    @Path('uuid') String uuid,
    @Part() File image,
  );

  @POST('{uuid}/invite')
  Future<Map<String, String>> createInviteCode(@Path('uuid') String uuid);

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
    @Query('roleId') String roleId,
  );

  @DELETE('{uuid}/member/{targetUuid}/role')
  Future<void> deleteUserRole(
    @Path('uuid') String uuid,
    @Path('targetUuid') String targetUuid,
    @Query('roleId') String roleId,
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
  Future<RoleListModel> getRole(
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
}
