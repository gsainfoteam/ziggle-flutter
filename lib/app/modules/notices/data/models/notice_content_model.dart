import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_content_entity.dart';

part 'notice_content_model.freezed.dart';
part 'notice_content_model.g.dart';

@freezed
class NoticeContentModel
    with _$NoticeContentModel
    implements NoticeContentEntity {
  const NoticeContentModel._();

  const factory NoticeContentModel({
    required int id,
    required Language lang,
    required String content,
    DateTime? deadline,
    required DateTime createdAt,
  }) = _NoticeModel;

  factory NoticeContentModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeContentModelFromJson(json);
}
