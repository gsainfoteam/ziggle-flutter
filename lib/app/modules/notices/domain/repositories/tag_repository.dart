import '../entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> searchTags(String query);
}
