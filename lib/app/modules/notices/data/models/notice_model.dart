import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notice_entity.dart';
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
    DateTime? currentDeadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default([]) List tags,
    required List<NoticeContentModel> contents,
    required List<NoticeReactionModel> reactions,
    required String author,
    @Default([]) List<String> imagesUrl,
    @Default([]) List<String> documentsUrl,
    @Default(false) bool reminder,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
  factory NoticeModel.fromEntity(NoticeEntity entity) => NoticeModel(
        id: entity.id,
        views: entity.views,
        currentDeadline: entity.currentDeadline,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        deletedAt: entity.deletedAt,
        tags: entity.tags,
        contents: entity.contents.map(NoticeContentModel.fromEntity).toList(),
        reactions:
            entity.reactions.map(NoticeReactionModel.fromEntity).toList(),
        author: entity.author,
        imagesUrl: entity.imagesUrl,
        documentsUrl: entity.documentsUrl,
        reminder: entity.reminder,
      );
}
