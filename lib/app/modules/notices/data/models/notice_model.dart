import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notice_entity.dart';
import 'tag_model.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel implements NoticeEntity {
  const factory NoticeModel({
    required int id,
    required String title,
    required int views,
    required String body,
    DateTime? deadline,
    required DateTime createdAt,
    @Default([]) List<String> imagesUrl,
    @Default([]) List<TagModel> tags,
    required String author,
    required bool reminder,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
}
