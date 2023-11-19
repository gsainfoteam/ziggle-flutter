import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/additional_write_entity.dart';

part 'rest_additional_write_model.freezed.dart';
part 'rest_additional_write_model.g.dart';

@freezed
class RestAdditionalWriteModel
    with _$RestAdditionalWriteModel
    implements AdditionalWriteEntity {
  const factory RestAdditionalWriteModel({
    String? title,
    required String body,
    DateTime? deadline,
  }) = _RestAdditionalWriteModel;

  factory RestAdditionalWriteModel.fromJson(Map<String, dynamic> json) =>
      _$RestAdditionalWriteModelFromJson(json);
}
