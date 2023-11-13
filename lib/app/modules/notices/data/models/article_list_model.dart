import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/article_list_entity.dart';
import 'article_summary_model.dart';

part 'article_list_model.freezed.dart';
part 'article_list_model.g.dart';

@freezed
class ArticleListModel with _$ArticleListModel implements ArticleListEntity {
  const factory ArticleListModel({
    required List<ArticleSummaryModel> list,
    required int total,
  }) = _ArticleListModel;

  factory ArticleListModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleListModelFromJson(json);
}
