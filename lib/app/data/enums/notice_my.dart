import 'package:ziggle/app/data/enums/article_type.dart';

enum NoticeMy {
  own(ArticleType.my),
  reminders(ArticleType.reminders);

  final ArticleType type;

  const NoticeMy(this.type);
}
