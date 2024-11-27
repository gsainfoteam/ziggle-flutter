import 'dart:io';

import 'package:ziggle/app/modules/groups/data/data_sources/models/group_model.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';

abstract class GroupRepository {
  Future<GroupModel> createGroup({
    required String name,
    File? image,
    required String description,
    String? notionPageId,
  });

  Future<GroupListEntity> getGroups();

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
}
