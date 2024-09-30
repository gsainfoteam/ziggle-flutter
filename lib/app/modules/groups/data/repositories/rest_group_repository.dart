import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/group_api.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/notion_api.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

@Injectable(as: GroupRepository)
class RestGroupRepository implements GroupRepository {
  final GroupApi _api;
  final NotionApi _notionApi;

  RestGroupRepository(
    this._api,
    this._notionApi,
  );

  @override
  Future<GroupEntity> createGroup({
    required String name,
    required String description,
    String? notionPageId,
    File? image,
  }) async {
    final createdGroup = await _api.createGroup(CreateGroupModel(
      name: name,
      description: description,
      notionPageId: notionPageId,
    ));
    //_api.uploadImage(createdGroup.uuid, image);
    return createdGroup;
  }
}
