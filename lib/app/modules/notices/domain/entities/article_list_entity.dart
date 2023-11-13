import 'article_summary_entity.dart';

class ArticleListEntity {
  final List<ArticleSummaryEntity> list;
  final int total;

  ArticleListEntity({
    required this.list,
    required this.total,
  });
}
