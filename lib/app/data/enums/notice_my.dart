import 'package:get/get.dart';
import 'package:ziggle/app/data/enums/article_type.dart';

enum NoticeMy {
  own(ArticleType.my),
  reminders(ArticleType.reminders);

  final ArticleType type;

  const NoticeMy(this.type);
}

extension ArticleTypeMyExtension on ArticleType {
  NoticeMy? get my => NoticeMy.values.firstWhereOrNull((e) => e.type == this);
}
