import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_document_entity.dart';

part 'notice_document_model.freezed.dart';
part 'notice_document_model.g.dart';

@freezed
sealed class NoticeDocumentModel
    with _$NoticeDocumentModel
    implements NoticeDocumentEntity {
  const NoticeDocumentModel._();

  const factory NoticeDocumentModel({
    required String name,
    required String url,
    // 필요한 만큼 String 필드 추가
  }) = _NoticeDocumentModel;

  factory NoticeDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeDocumentModelFromJson(json);
}
