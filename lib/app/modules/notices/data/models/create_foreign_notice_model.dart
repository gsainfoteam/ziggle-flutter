import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';

part 'create_foreign_notice_model.freezed.dart';
part 'create_foreign_notice_model.g.dart';

@freezed
class CreateForeignNoticeModel with _$CreateForeignNoticeModel {
  const factory CreateForeignNoticeModel({
    required Language lang,
    String? title,
    required String body,
    DateTime? deadline,
  }) = _CreateForeignNoticeModel;

  factory CreateForeignNoticeModel.fromJson(Map<String, dynamic> json) =>
      _$CreateForeignNoticeModelFromJson(json);
}
