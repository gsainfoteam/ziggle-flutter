import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_content_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

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
    required String content,
    DateTime? deadline,
    required DateTime createdAt,
  }) = _NoticeModel;

  factory NoticeContentModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeContentModelFromJson(json);
  factory NoticeContentModel.fromEntity(NoticeContentEntity entity) =>
      NoticeContentModel(
        id: entity.id,
        lang: entity.lang,
        content: entity.content,
        deadline: entity.deadline,
        createdAt: entity.createdAt,
      );
}
