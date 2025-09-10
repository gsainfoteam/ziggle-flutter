import 'dart:convert';
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
    @Default('{}') String titlesJson,
    @Default('{}') String bodiesJson,
    @Default(-1) int typeIndex,
    @Default('') String tagsJson,
    @Property(type: PropertyType.date) DateTime? deadline,
  }) = _NoticeWriteDraftModel;

  const NoticeWriteDraftModel._();

  Map<Language, String> get titles {
    try {
      final Map<String, dynamic> json = jsonDecode(titlesJson);
      return json.map(
        (key, value) => MapEntry(Language.values.byName(key), value.toString()),
      );
    } catch (e) {
      return {};
    }
  }

  Map<Language, String> get bodies {
    try {
      final Map<String, dynamic> json = jsonDecode(bodiesJson);
      return json.map(
        (key, value) => MapEntry(Language.values.byName(key), value.toString()),
      );
    } catch (e) {
      return {};
    }
  }

  NoticeType? get type => typeIndex >= 0 ? NoticeType.values[typeIndex] : null;

  List<String> get tags {
    try {
      return tagsJson.isEmpty ? [] : tagsJson.split(',');
    } catch (e) {
      return [];
    }
  }

  NoticeWriteDraftEntity toEntity() => NoticeWriteDraftEntity(
    titles: titles,
    bodies: bodies,
    type: type,
    tags: tags,
    deadline: deadline,
  );

  factory NoticeWriteDraftModel.fromEntity(NoticeWriteDraftEntity entity) =>
      NoticeWriteDraftModel(
        titlesJson: jsonEncode(
          entity.titles.map((key, value) => MapEntry(key.name, value)),
        ),
        bodiesJson: jsonEncode(
          entity.bodies.map((key, value) => MapEntry(key.name, value)),
        ),
        typeIndex: entity.type?.index ?? -1,
        tagsJson: entity.tags.join(','),
        deadline: entity.deadline,
      );
}
