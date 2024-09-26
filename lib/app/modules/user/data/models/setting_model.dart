import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'setting_model.freezed.dart';
part 'setting_model.g.dart';

@HiveType(typeId: 1)
@freezed
class SettingModel with _$SettingModel {
  const SettingModel._();

  const factory SettingModel({
    @HiveField(0) required String language,
    @HiveField(1, defaultValue: false) required bool developerOption,
  }) = _SettingModel;

  factory SettingModel.init() => SettingModel(
        language: AppLocaleUtils.findDeviceLocale().name,
        developerOption: false,
      );
}
