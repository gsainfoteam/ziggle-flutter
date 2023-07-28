import 'dart:io';

import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/app/data/model/write_store.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/provider/db.dart';

const _writeStoreKey = 'write_store';

class WriteRepository {
  final ApiProvider _provider;
  final DbProvider _dbProvider;

  WriteRepository(this._provider, this._dbProvider);

  Future<List<String>> uploadImages(Iterable<String> imagePaths) async {
    final result = await _provider.uploadImages(
      imagePaths.map((e) => File(e)).toList(),
    );
    return result;
  }

  Future<ArticleResponse> write(WriteStore data) async {
    final List<dynamic> tagSearchResult = await Future.wait<dynamic>(
      data.tags.map(
        (tag) => _provider
            .getTag(tag)
            .then<dynamic>((v) => v)
            .catchError((_) => tag),
      ),
    );
    final existTags = tagSearchResult.whereType<TagResponse>().map((e) => e.id);
    final requireToCreateTags = tagSearchResult.whereType<String>();
    final createdTags = await Future.wait(
      requireToCreateTags
          .map(_provider.createTag)
          .map((e) => e.then((value) => value.id)),
    );

    final imageKeys = await uploadImages(data.imagePaths);

    final result = await _provider.writeNotice(
      data.toRequest(
        tags: [...existTags, ...createdTags],
        imageKeys: imageKeys,
      ),
    );
    return result;
  }

  Future<void> save(WriteStore data) async {
    if (data.isEmpty) {
      await _removeSaved();
      return;
    }
    await _dbProvider.setSetting(_writeStoreKey, data);
  }

  Future<void> _removeSaved() async {
    await _dbProvider.removeSetting(_writeStoreKey);
  }

  WriteStore? getSaved() {
    return _dbProvider.getSetting<WriteStore?>(_writeStoreKey);
  }
}
