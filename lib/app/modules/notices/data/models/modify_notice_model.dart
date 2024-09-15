import 'package:freezed_annotation/freezed_annotation.dart';

part 'modify_notice_model.freezed.dart';
part 'modify_notice_model.g.dart';

@freezed
class ModifyNoticeModel with _$ModifyNoticeModel {
  const factory ModifyNoticeModel({
    required String body,
    DateTime? deadline,
  }) = _ModifyNoticeModel;

  factory ModifyNoticeModel.fromJson(Map<String, dynamic> json) =>
      _$ModifyNoticeModelFromJson(json);
}
