import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

part 'article_response.freezed.dart';
part 'article_response.g.dart';

@Freezed()
class ArticleResponse with _$ArticleResponse {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory ArticleResponse({
    required int id,
    required String title,
    required int views,
    required String body,
    DateTime? deadline,
    required DateTime createdAt,
    List<String>? imagesUrl,
    @Default([]) List<TagResponse> tags,
    required String author,
  }) = _ArticleResponse;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);
}
