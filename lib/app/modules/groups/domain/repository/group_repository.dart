import 'dart:io';

import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<GroupEntity> createGroup({
    required String name,
    required String description,
    required String notionPageId,
    // required File image,
  });
}
