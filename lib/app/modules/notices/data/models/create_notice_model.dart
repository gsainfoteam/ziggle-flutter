import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';

part 'create_notice_model.freezed.dart';
part 'create_notice_model.g.dart';

@freezed
class CreateNoticeModel with _$CreateNoticeModel {
  const factory CreateNoticeModel({
    required String title,
    required String body,
    DateTime? deadline,
    required NoticeCategory category,
    @Default([]) List<int> tags,
    @Default([]) List<String> images,
    @Default([]) List<String> documents,
  }) = _CreateNoticeModel;

  factory CreateNoticeModel.fromJson(Map<String, dynamic> json) =>
      _$CreateNoticeModelFromJson(json);
}
