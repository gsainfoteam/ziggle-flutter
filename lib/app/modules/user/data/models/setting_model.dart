import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'setting_model.freezed.dart';

@freezed
sealed class SettingModel with _$SettingModel {
  const SettingModel._();

  const factory SettingModel({
    required Language language,
    @Default(false) bool developerOption,
  }) = _SettingModel;

  factory SettingModel.init() => SettingModel(
    language: Language.values.byName(AppLocaleUtils.findDeviceLocale().name),
    developerOption: false,
  );
}
