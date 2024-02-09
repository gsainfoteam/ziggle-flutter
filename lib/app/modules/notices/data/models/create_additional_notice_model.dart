import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/notice_to.dart';

part 'create_additional_notice_model.freezed.dart';
part 'create_additional_notice_model.g.dart';

@freezed
class CreateAdditionalNoticeModel with _$CreateAdditionalNoticeModel {
  const factory CreateAdditionalNoticeModel({
    String? title,
    required String body,
    DateTime? deadline,
    NoticeTo? to,
  }) = _CreateAdditionalNoticeModel;

  factory CreateAdditionalNoticeModel.fromJson(Map<String, dynamic> json) =>
      _$CreateAdditionalNoticeModelFromJson(json);
}
