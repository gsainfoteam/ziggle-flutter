import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/content_entity.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class ContentModel with _$ContentModel implements ContentEntity {
  const factory ContentModel({
    required int id,
    required String lang,
    required String title,
    required String body,
    DateTime? deadline,
    required DateTime createdAt,
  }) = _ContentModel;

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
}
