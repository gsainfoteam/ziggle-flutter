import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/data/models/content_model.dart';

import '../../domain/entities/notice_entity.dart';
import 'tag_model.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel implements NoticeEntity {
  const factory NoticeModel({
    required int id,
    required int views,
    DateTime? currentDeadline,
    required DateTime createdAt,
    required List<ContentModel> contents,
    @Default([]) List<String> imagesUrl,
    @Default([]) List<TagModel> tags,
    required String author,
    required bool reminder,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
}
