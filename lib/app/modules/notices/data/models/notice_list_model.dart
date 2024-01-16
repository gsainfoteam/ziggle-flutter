import "package:freezed_annotation/freezed_annotation.dart";

import "../../domain/entities/notice_list_entity.dart";
import "notice_model.dart";

part 'notice_list_model.freezed.dart';
part 'notice_list_model.g.dart';

@freezed
class NoticeListModel with _$NoticeListModel implements NoticeListEntity {
  const NoticeListModel._();

  const factory NoticeListModel({
    required int total,
    required List<NoticeModel> list,
  }) = _NoticeListModel;

  factory NoticeListModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeListModelFromJson(json);
}
