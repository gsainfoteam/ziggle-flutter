import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/article_entity.dart';
import 'tag_model.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class ArticleModel with _$ArticleModel implements ArticleEntity {
  const factory ArticleModel({
    required int id,
    required String title,
    required int views,
    required String body,
    DateTime? deadline,
    required DateTime createdAt,
    List<String>? imagesUrl,
    @Default([]) List<TagModel> tags,
    required String author,
    required bool reminder,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}
