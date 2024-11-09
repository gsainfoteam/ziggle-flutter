import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'notice_write_draft_model.freezed.dart';
part 'notice_write_draft_model.g.dart';

@freezed
class NoticeWriteDraftModel with _$NoticeWriteDraftModel {
  const NoticeWriteDraftModel._();

  @HiveType(typeId: 2)
  const factory NoticeWriteDraftModel({
    @HiveField(0) @Default({}) Map<Language, String> titles,
    @HiveField(1) @Default({}) Map<Language, String> bodies,
    @HiveField(2) NoticeType? type,
    @HiveField(3) @Default([]) List<String> tags,
    @HiveField(4) DateTime? deadline,
  }) = _NoticeWriteDraftModel;

  NoticeWriteDraftEntity toEntity() => NoticeWriteDraftEntity(
        titles: titles,
        bodies: bodies,
        type: type,
        tags: tags,
        deadline: deadline,
      );

  factory NoticeWriteDraftModel.fromEntity(NoticeWriteDraftEntity entity) =>
      NoticeWriteDraftModel(
        titles: entity.titles,
        bodies: entity.bodies,
        type: entity.type,
        tags: entity.tags,
        deadline: entity.deadline,
      );
}
