import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

part 'article_summary_response.freezed.dart';
part 'article_summary_response.g.dart';

@freezed
class ArticleSummaryResponse with _$ArticleSummaryResponse {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory ArticleSummaryResponse({
    required int id,
    required String title,
    required String author,
    required int views,
    required DateTime? deadline,
    required DateTime createdAt,
    required String? imageUrl,
    @Default([]) List<TagResponse> tags,
  }) = _ArticleSummaryResponse;

  factory ArticleSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleSummaryResponseFromJson(json);
}
