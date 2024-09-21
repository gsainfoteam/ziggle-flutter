import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<List<TagEntity>> searchTags(String search);
}
