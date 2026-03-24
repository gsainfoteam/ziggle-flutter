import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';

part 'get_notice_query_model.freezed.dart';
part 'get_notice_query_model.g.dart';

@Freezed(toJson: true)
sealed class GetNoticeQueryModel with _$GetNoticeQueryModel {
  const factory GetNoticeQueryModel({
    required Language lang,
    @Default(false) bool isViewed,
  }) = _GetNoticeQueryModel;
}
