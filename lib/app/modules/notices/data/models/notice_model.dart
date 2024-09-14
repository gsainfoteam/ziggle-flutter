import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';
import 'package:ziggle/gen/strings.g.dart';

import 'author_model.dart';
import 'notice_content_model.dart';
import 'notice_reaction_model.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel implements NoticeEntity {
  const NoticeModel._();

  const factory NoticeModel({
    required int id,
    required int views,
    @Default([AppLocale.ko]) List<AppLocale> langs,
    DateTime? deadline,
    DateTime? currentDeadline,
    required DateTime createdAt,
    DateTime? deletedAt,
    @Default([]) List<String> tags,
    required String title,
    required String content,
    @Default([]) List<NoticeContentModel> additionalContents,
    required List<NoticeReactionModel> reactions,
    required AuthorModel author,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> documentUrls,
    @Default(false) bool isReminded,
    required NoticeCategory category,
    String? groupName,
    DateTime? publishedAt,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
  factory NoticeModel.fromEntity(NoticeEntity entity) => NoticeModel(
        id: entity.id,
        views: entity.views,
        langs: entity.langs,
        deadline: entity.deadline,
        currentDeadline: entity.currentDeadline,
        createdAt: entity.createdAt,
        deletedAt: entity.deletedAt,
        tags: entity.tags,
        title: entity.title,
        content: entity.content,
        reactions:
            entity.reactions.map(NoticeReactionModel.fromEntity).toList(),
        additionalContents: entity.additionalContents
            .map(NoticeContentModel.fromEntity)
            .toList(),
        author: AuthorModel.fromEntity(entity.author),
        imageUrls: entity.imageUrls,
        documentUrls: entity.documentUrls,
        isReminded: entity.isReminded,
        category: entity.category,
        groupName: entity.groupName,
        publishedAt: entity.publishedAt,
      );
}
