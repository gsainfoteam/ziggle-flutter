import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_result_model.freezed.dart';
part 'translation_result_model.g.dart';

@freezed
class TranslationResultModel with _$TranslationResultModel {
  const factory TranslationResultModel({
    required String text,
  }) = _TranslationResultModel;

  factory TranslationResultModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationResultModelFromJson(json);
}
