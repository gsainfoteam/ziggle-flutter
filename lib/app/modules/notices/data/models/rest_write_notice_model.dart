import 'package:freezed_annotation/freezed_annotation.dart';

part 'rest_write_notice_model.freezed.dart';
part 'rest_write_notice_model.g.dart';

@freezed
class RestWriteNoticeModel with _$RestWriteNoticeModel {
  const factory RestWriteNoticeModel({
    required String title,
    required String body,
    required DateTime? deadline,
    required List<String>? images,
    required List<int>? tags,
  }) = _RestWriteNoticeModel;

  factory RestWriteNoticeModel.fromJson(Map<String, dynamic> json) =>
      _$RestWriteNoticeModelFromJson(json);
}
