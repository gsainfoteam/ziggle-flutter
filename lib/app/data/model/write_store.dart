import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdown/markdown.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/app/data/model/article_request.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

part 'write_store.freezed.dart';
part 'write_store.g.dart';

@freezed
class WriteStore with _$WriteStore {
  const WriteStore._();

  @HiveType(typeId: 0)
  const factory WriteStore({
    @HiveField(0) required String title,
    @HiveField(1) required String body,
    @HiveField(2) required DateTime? deadline,
    @HiveField(3) required Iterable<String> imagePaths,
    @HiveField(4) required List<String> tags,
    @HiveField(5) required ArticleType? type,
  }) = _WriteStore;

  bool get isEmpty =>
      title.isEmpty &&
      body.isEmpty &&
      deadline == null &&
      imagePaths.isEmpty &&
      tags.isEmpty &&
      type == null;

  toRequest({required Iterable<int> tags, required List<String>? imageKeys}) {
    assert(type != null);
    return ArticleRequest(
      title: title,
      body: markdownToHtml(body),
      deadline: deadline,
      images: imageKeys,
      tags: [type!.id, ...tags],
    );
  }

  toResponse(String author) => ArticleResponse(
        id: 0,
        title: title,
        views: 0,
        body: body,
        createdAt: DateTime.now(),
        author: author,
        reminder: false,
        tags: tags.map((e) => TagResponse(id: 0, name: e)).toList(),
        deadline: deadline,
      );
}
