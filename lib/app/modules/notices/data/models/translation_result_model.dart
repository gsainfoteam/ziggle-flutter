import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'translation_result_model.freezed.dart';
part 'translation_result_model.g.dart';

@freezed
class TranslationResultModel with _$TranslationResultModel {
  const factory TranslationResultModel({
    required String text,
    required AppLocale lang,
  }) = _TranslationResultModel;

  factory TranslationResultModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationResultModelFromJson(json);
}
