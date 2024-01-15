import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notice_entity.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel implements NoticeEntity {
  const NoticeModel._();

  const factory NoticeModel({
    required int id,
    required int views,
    DateTime? currentDeadline,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    @Default([]) List tags,
    required List contents,
    required List reactions,
    required String author,
    String? imageUrl,
    String? documentUrl,
    List<String>? imagesUrl,
    List<String>? documentsUrl,
    required String title,
    required String body,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);

  @override
  List<String> get documentsUrl =>
      super.documentsUrl ?? [if (documentUrl != null) documentUrl!];

  @override
  List<String> get imagesUrl =>
      super.documentsUrl ?? [if (imageUrl != null) imageUrl!];
}
