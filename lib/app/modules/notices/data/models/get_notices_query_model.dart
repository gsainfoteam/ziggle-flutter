import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/data/enums/notice_my.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_sort.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'get_notices_query_model.freezed.dart';
part 'get_notices_query_model.g.dart';

@Freezed(toJson: true)
class GetNoticesQueryModel with _$GetNoticesQueryModel {
  @JsonSerializable(includeIfNull: false)
  const factory GetNoticesQueryModel({
    int? offset,
    int? limit,
    AppLocale? lang,
    String? search,
    List<String>? tags,
    NoticeSort? orderBy,
    NoticeMy? my,
    NoticeCategory? category,
  }) = _GetNoticesQueryModel;
}
