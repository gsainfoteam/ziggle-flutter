import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'notice_write_model.freezed.dart';

@freezed
class NoticeWriteModel with _$NoticeWriteModel implements NoticeWriteEntity {
  const NoticeWriteModel._();

  const factory NoticeWriteModel({
    required String title,
    required String body,
    DateTime? deadline,
    @Default([]) Iterable<String> imagePaths,
    @Default([]) List<String> tags,
    required int? typeIndex,
  }) = _NoticeWriteModel;

  @override
  NoticeType? get type =>
      typeIndex != null ? NoticeType.writables[typeIndex!] : null;
}
