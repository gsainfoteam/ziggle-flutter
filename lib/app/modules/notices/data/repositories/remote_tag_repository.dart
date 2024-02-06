import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';
import '../data_sources/remote/tag_api.dart';

@Injectable(as: TagRepository)
class RemoteTagRepository implements TagRepository {
  final TagApi _api;

  RemoteTagRepository(this._api);

  @override
  Future<TagEntity> createTag(String name) {
    return _api.createTag(name);
  }

  @override
  Future<TagEntity?> getTag(String name) async {
    try {
      return await _api.findTag(name);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<List<TagEntity>> searchTags(String query) {
    return _api.searchTags(query);
  }
}
