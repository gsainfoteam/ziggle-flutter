import 'package:collection/collection.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../enums/notice_reaction.dart';
import 'author_entity.dart';
import 'notice_content_entity.dart';
import 'notice_reaction_entity.dart';

class NoticeEntity {
  final int id;
  final int views;
  final List<AppLocale> langs;
  final DateTime? deadline;
  final DateTime? currentDeadline;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final List<String> tags;
  final String title;
  final String content;
  final List<NoticeContentEntity> additionalContents;
  final List<NoticeReactionEntity> reactions;
  final AuthorEntity author;
  final List<String> imageUrls;
  final List<String> documentUrls;
  final bool isReminded;

  NoticeEntity({
    required this.id,
    required this.views,
    required this.langs,
    required this.deadline,
    required this.currentDeadline,
    required this.createdAt,
    required this.deletedAt,
    required this.tags,
    required this.title,
    required this.content,
    required this.additionalContents,
    required this.reactions,
    required this.author,
    required this.imageUrls,
    required this.documentUrls,
    required this.isReminded,
  });

  factory NoticeEntity.fromId(int id) => NoticeEntity(
        id: id,
        views: 0,
        langs: [],
        deadline: null,
        currentDeadline: null,
        createdAt: DateTime.now(),
        deletedAt: null,
        tags: [],
        title: '',
        content: '',
        additionalContents: [],
        reactions: [],
        imageUrls: [],
        documentUrls: [],
        author: AuthorEntity(name: '', uuid: ''),
        isReminded: false,
      );
}

extension NoticeEntityExtension on NoticeEntity {
  static const maxTimeToEdit = Duration(minutes: 15);

  int reactionsBy(NoticeReaction reaction) =>
      reactions.firstWhereOrNull((e) => e.emoji == reaction.emoji)?.count ?? 0;
  int get likes => reactionsBy(NoticeReaction.like);
  bool reacted(NoticeReaction reaction) =>
      reactions.firstWhereOrNull((e) => e.emoji == reaction.emoji)?.isReacted ??
      false;
  bool get canEdit => DateTime.now().difference(createdAt) < maxTimeToEdit;
}
