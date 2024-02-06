import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> searchTags(String query);
  Future<TagEntity?> getTag(String name);
  Future<TagEntity> createTag(String name);
}
