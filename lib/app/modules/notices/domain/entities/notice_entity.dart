import 'package:ziggle/app/modules/notices/domain/entities/content_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

import 'tag_entity.dart';

class NoticeEntity {
  final int id;
  final int views;
  final DateTime? currentDeadline;
  final DateTime createdAt;
  final String title;
  final String body;
  final List<ContentEntity> contents;
  final List<String> imagesUrl;
  final List<TagEntity> tags;
  final String authorId;
  final String author;
  final bool reminder;

  NoticeEntity({
    required this.id,
    this.views = 0,
    this.currentDeadline,
    required this.createdAt,
    required this.title,
    required this.body,
    required this.contents,
    this.imagesUrl = const [],
    this.tags = const [],
    this.authorId = "",
    this.author = "",
    this.reminder = false,
  }) : assert(contents.isNotEmpty);
}

extension _ContentEntityListExtension on Iterable<ContentEntity> {
  Iterable<ContentEntity> get _localeds => where(
      (content) => content.lang == LocaleSettings.currentLocale.languageCode);
}

extension ContentEntityListExtension on Iterable<ContentEntity> {
  Iterable<ContentEntity> get localeds => [localed, ..._localeds.additionals];
  ContentEntity get localed => _localeds.mains.firstOrNull ?? first;
  Iterable<ContentEntity> get mains => where((content) => content.id == 1);
  Iterable<ContentEntity> get additionals =>
      where((content) => content.id != 1);
  Iterable<ContentEntity> get koreans =>
      where((content) => content.lang == "ko");
  ContentEntity get korean => mains.koreans.firstOrNull ?? first;
  Iterable<ContentEntity> get englishes =>
      where((content) => content.lang == "en");
  ContentEntity? get english => mains.englishes.firstOrNull;
}
