import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
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
  final List<ImageProvider> images;
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
    required this.images,
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
        images: [],
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
        images: imageUrls.map((url) => NetworkImage(url)).toList(),
        documentUrls: [],
        isReminded: isReminded,
        publishedAt: null,
        groupName: null,
        category: category,
      );
  factory NoticeEntity.fromDraft({
    required NoticeWriteDraftEntity draft,
    required UserEntity user,
  }) =>
      NoticeEntity(
        id: 0,
        views: 0,
        langs: [AppLocale.ko],
        deadline: draft.deadline,
        currentDeadline: draft.deadline,
        createdAt: DateTime.now(),
        deletedAt: null,
        tags: draft.tags,
        title: draft.titles[AppLocale.ko] ?? '',
        content: draft.bodies[AppLocale.ko] ?? '',
        additionalContents: [],
        reactions: [],
        author: AuthorEntity(name: user.name, uuid: ''),
        images: draft.images.map((file) => FileImage(file)).toList(),
        documentUrls: [],
        isReminded: false,
        publishedAt: null,
        groupName: null,
        category: NoticeCategory.fromType(draft.type!)!,
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

  bool get isCertified => false;

  NoticeEntity copyWith({
    DateTime? publishedAt,
    List<NoticeReactionEntity>? reactions,
  }) =>
      NoticeEntity(
        id: id,
        views: views,
        langs: langs,
        deadline: deadline,
        currentDeadline: currentDeadline,
        createdAt: createdAt,
        deletedAt: deletedAt,
        tags: tags,
        title: title,
        content: content,
        additionalContents: additionalContents,
        reactions: reactions ?? this.reactions,
        author: author,
        images: images,
        documentUrls: documentUrls,
        isReminded: isReminded,
        publishedAt: publishedAt ?? this.publishedAt,
        groupName: groupName,
        category: category,
      );

  NoticeEntity addReaction(NoticeReaction reaction) {
    final reactions = [
      ...this.reactions.where((e) => e.emoji != reaction.emoji),
      NoticeReactionEntity(
        emoji: reaction.emoji,
        count: reactionsBy(reaction) + 1,
        isReacted: true,
      ),
    ];
    return copyWith(reactions: reactions);
  }

  NoticeEntity removeReaction(NoticeReaction reaction) {
    final newCount = reactionsBy(reaction) - 1;
    final reactions = [
      ...this.reactions.where((e) => e.emoji != reaction.emoji),
      if (newCount > 0)
        NoticeReactionEntity(
          emoji: reaction.emoji,
          count: newCount,
          isReacted: false,
        ),
    ];
    return copyWith(reactions: reactions);
  }
}
