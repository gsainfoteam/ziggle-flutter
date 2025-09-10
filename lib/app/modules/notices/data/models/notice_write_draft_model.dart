import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'notice_write_draft_model.freezed.dart';

@freezed
sealed class NoticeWriteDraftModel with _$NoticeWriteDraftModel {
  @Entity(realClass: NoticeWriteDraftModel)
  factory NoticeWriteDraftModel({
    @Id(assignable: true) @Default(0) int id,
    @Default({}) Map<Language, String> titles,
    @Default({}) Map<Language, String> bodies,
    NoticeType? type,
    @Default([]) List<String> tags,
    @Property(type: PropertyType.date) DateTime? deadline,
  }) = _NoticeWriteDraftModel;

  const NoticeWriteDraftModel._();

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
