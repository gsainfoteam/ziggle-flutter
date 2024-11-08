import 'package:ziggle/app/modules/groups/data/data_sources/models/group_response_model.dart';

abstract class GroupRepository {
  Future<GroupResponseModel> createGroup({
    required String name,
    required String description,
    required String? notionPageId,
    // required File image,
  });
}
