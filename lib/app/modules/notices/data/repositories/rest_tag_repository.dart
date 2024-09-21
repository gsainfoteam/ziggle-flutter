import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/tag_api.dart';
import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/tag_repository.dart';

@Injectable(as: TagRepository)
class RestTagRepository implements TagRepository {
  final TagApi _api;
  RestTagRepository(this._api);

  @override
  Future<List<TagEntity>> searchTags(String search) {
    return _api.searchTags(search);
  }
}
