import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_content_entity.dart';

part 'notice_content_model.freezed.dart';
part 'notice_content_model.g.dart';

@freezed
class NoticeContentModel
    with _$NoticeContentModel
    implements NoticeContentEntity {
  const NoticeContentModel._();

  const factory NoticeContentModel({
    required int id,
    required AppLocale lang,
    @Default('') String title,
    required String body,
    DateTime? deadline,
    required DateTime createdAt,
  }) = _NoticeModel;

  factory NoticeContentModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeContentModelFromJson(json);
  factory NoticeContentModel.fromEntity(NoticeContentEntity entity) =>
      NoticeContentModel(
        id: entity.id,
        lang: entity.lang,
        title: entity.title,
        body: entity.body,
        deadline: entity.deadline,
        createdAt: entity.createdAt,
      );
}
