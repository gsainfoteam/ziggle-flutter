import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/create_group_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_response_model.dart';
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
  Future<GroupResponseModel> createGroup({
    required String name,
    required String description,
    String? notionPageId,
    File? image,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('그룹 이름은 비워둘 수 없습니다.');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('그룹 설명은 비워둘 수 없습니다.');
    }
    try {
      final createdGroup = await _api.createGroup(CreateGroupModel(
        name: name,
        description: description,
        notionPageId: notionPageId,
      ));

      if (image != null) {
        // await _api.uploadImage(createdGroup.uuid, image);
      }

      return createdGroup;
    } catch (e) {
      throw Exception('그룹 생성 중 오류가 발생했습니다: $e');
    }
  }
}
