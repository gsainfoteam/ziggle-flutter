import 'package:collection/collection.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';
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
  final DateTime? publishedAt;
  final String? groupName;
  final NoticeCategory category;

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
    required this.publishedAt,
    required this.groupName,
    required this.category,
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
        publishedAt: null,
        groupName: null,
        category: NoticeCategory.etc,
      );
  factory NoticeEntity.mock({
    DateTime? deadline,
    required DateTime createdAt,
    List<String> tags = const [],
    required String title,
    required String content,
    List<NoticeReactionEntity> reactions = const [],
    String authorName = '홍길동',
    List<String> imageUrls = const [],
    bool isReminded = false,
    NoticeCategory category = NoticeCategory.etc,
  }) =>
      NoticeEntity(
        id: 0,
        views: 0,
        langs: [AppLocale.ko],
        deadline: deadline,
        currentDeadline: null,
        createdAt: createdAt,
        deletedAt: null,
        tags: tags,
        title: title,
        content: content,
        additionalContents: [],
        reactions: reactions,
        author: AuthorEntity(name: authorName, uuid: ''),
        imageUrls: imageUrls,
        documentUrls: [],
        isReminded: isReminded,
        publishedAt: null,
        groupName: null,
        category: category,
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
  bool get canRemind {
    if (currentDeadline == null) return false;
    if (currentDeadline!.toLocal().isBefore(DateTime.now())) return false;
    return true;
  }
}
