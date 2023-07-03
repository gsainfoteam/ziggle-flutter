import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_request.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class WriteRepository {
  final ApiProvider _provider;

  WriteRepository(this._provider);

  Future<List<String>> uploadImages(List<XFile> images) async {
    final result = await _provider.uploadImages(
      images.map((e) => File(e.path)).toList(),
    );
    return result;
  }

  Future<ArticleResponse> write({
    required String title,
    required String body,
    DateTime? deadline,
    List<String>? images,
    List<String> tags = const [],
    required ArticleType type,
  }) async {
    final List<dynamic> tagSearchResult = await Future.wait<dynamic>(
      tags.map(
          (tag) => _provider.getTag(tag).then((v) => v, onError: (_) => tag)),
    );
    final existTags = tagSearchResult.whereType<TagResponse>().map((e) => e.id);
    final requireToCreateTags = tagSearchResult.whereType<String>();
    final createdTags = await Future.wait(
      requireToCreateTags
          .map(_provider.createTag)
          .map((e) => e.then((value) => value.id)),
    );

    final result = await _provider.writeNotice(
      ArticleRequest(
        title: title,
        body: body,
        deadline: deadline,
        tags: [type.id, ...existTags, ...createdTags],
        images: images,
      ),
    );
    return result;
  }
}
