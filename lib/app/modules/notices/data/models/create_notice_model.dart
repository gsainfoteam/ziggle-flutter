import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_notice_model.freezed.dart';
part 'create_notice_model.g.dart';

@freezed
class CreateNoticeModel with _$CreateNoticeModel {
  const factory CreateNoticeModel({
    required String title,
    required String body,
    DateTime? deadline,
    @Default([]) List<int> tagIds,
    @Default([]) List<String> images,
    @Default([]) List<String> documents,
  }) = _CreateNoticeModel;

  factory CreateNoticeModel.fromJson(Map<String, dynamic> json) =>
      _$CreateNoticeModelFromJson(json);
}
