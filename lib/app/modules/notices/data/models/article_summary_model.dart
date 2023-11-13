import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/data/models/tag_model.dart';

import '../../domain/entities/article_summary_entity.dart';

part 'article_summary_model.freezed.dart';
part 'article_summary_model.g.dart';

@freezed
class ArticleSummaryModel
    with _$ArticleSummaryModel
    implements ArticleSummaryEntity {
  const factory ArticleSummaryModel({
    required int id,
    required String title,
    required String body,
    required String author,
    required int views,
    required DateTime? deadline,
    required DateTime createdAt,
    required String? imageUrl,
    @Default([]) List<TagModel> tags,
  }) = _ArticleSummaryModel;

  factory ArticleSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleSummaryModelFromJson(json);
}
