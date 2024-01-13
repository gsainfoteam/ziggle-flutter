import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/data/models/content_model.dart';
import 'package:ziggle/app/modules/notices/data/models/tag_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';

import '../../domain/entities/notice_summary_entity.dart';

part 'notice_summary_model.freezed.dart';
part 'notice_summary_model.g.dart';

@freezed
class NoticeSummaryModel
    with _$NoticeSummaryModel
    implements NoticeSummaryEntity {
  const NoticeSummaryModel._();

  const factory NoticeSummaryModel({
    required int id,
    required List<ContentModel> contents,
    required String author,
    required int views,
    required DateTime? currentDeadline,
    required DateTime createdAt,
    required String? imageUrl,
    @Default([]) List<TagModel> tags,
  }) = _NoticeSummaryModel;

  factory NoticeSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeSummaryModelFromJson(json);

  @override
  String get body => contents.localed.body;

  @override
  String get title => contents.localed.title ?? contents.korean.title!;
}
