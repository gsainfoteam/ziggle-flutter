import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';

part 'article_list_response.freezed.dart';
part 'article_list_response.g.dart';

@freezed
class ArticleListResponse with _$ArticleListResponse {
  const factory ArticleListResponse({
    required List<ArticleSummaryResponse> list,
    required int total,
  }) = _ArticleListResponse;

  factory ArticleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleListResponseFromJson(json);
}
