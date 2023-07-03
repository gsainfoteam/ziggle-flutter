import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_request.freezed.dart';
part 'article_request.g.dart';

@freezed
class ArticleRequest with _$ArticleRequest {
  const factory ArticleRequest({
    required String title,
    required String body,
    required DateTime? deadline,
    List<int>? tags,
    List<String>? images,
  }) = _ArticleRequest;

  factory ArticleRequest.fromJson(Map<String, dynamic> json) =>
      _$ArticleRequestFromJson(json);
}
