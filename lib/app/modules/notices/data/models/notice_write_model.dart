import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'notice_write_model.freezed.dart';
part 'notice_write_model.g.dart';

@freezed
class NoticeWriteModel with _$NoticeWriteModel implements NoticeWriteEntity {
  const NoticeWriteModel._();

  @HiveType(typeId: 1)
  const factory NoticeWriteModel({
    @HiveField(0) required String title,
    @HiveField(1) required String body,
    @HiveField(2) DateTime? deadline,
    @HiveField(3) @Default([]) Iterable<String> imagePaths,
    @HiveField(4) @Default([]) List<String> tags,
    @HiveField(5) required int? typeIndex,
  }) = _NoticeWriteModel;

  @override
  NoticeType? get type =>
      typeIndex != null ? NoticeType.writables[typeIndex!] : null;
}
