import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notice_list_entity.dart';
import 'notice_summary_model.dart';

part 'notice_list_model.freezed.dart';
part 'notice_list_model.g.dart';

@freezed
class NoticeListModel with _$NoticeListModel implements NoticeListEntity {
  const factory NoticeListModel({
    required List<NoticeSummaryModel> list,
    required int total,
  }) = _NoticeListModel;

  factory NoticeListModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeListModelFromJson(json);
}
