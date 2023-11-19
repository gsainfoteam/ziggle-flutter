import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/translation_write_entity.dart';

part 'rest_translation_write_model.freezed.dart';
part 'rest_translation_write_model.g.dart';

@freezed
class RestTranslationWriteModel
    with _$RestTranslationWriteModel
    implements TranslationWriteEntity {
  const factory RestTranslationWriteModel({
    @Default('en') String lang,
    String? title,
    required String body,
    DateTime? deadline,
  }) = _RestTranslationWriteModel;

  factory RestTranslationWriteModel.fromJson(Map<String, dynamic> json) =>
      _$RestTranslationWriteModelFromJson(json);
}
