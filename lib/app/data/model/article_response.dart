import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_response.freezed.dart';
part 'article_response.g.dart';

@freezed
class ArticleResponse with _$ArticleResponse {
  const factory ArticleResponse({
    required int id,
    required String title,
    required int views,
    required String body,
    required DateTime? deatline,
    required DateTime createdAt,
    required List<String>? imagesUrl,
    required List<String> tags,
    required String author,
  }) = _ArticleResponse;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
}
