import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'setting_model.freezed.dart';

@freezed
class SettingModel extends HiveObject with _$SettingModel {
  SettingModel._();

  const factory SettingModel({
    required String language,
    @Default(false) bool developerOption,
  }) = _SettingModel;

  factory SettingModel.init() => SettingModel(
        language: AppLocaleUtils.findDeviceLocale().name,
        developerOption: false,
      );
}
