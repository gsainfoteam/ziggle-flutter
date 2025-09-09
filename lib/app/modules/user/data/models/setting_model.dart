import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:ziggle/gen/strings.g.dart';

@Entity()
@freezed
class SettingModel {
  @Id()
  int id;
  String language;
  bool developerOption;

  SettingModel(
      {this.id = 0, required this.language, required this.developerOption});

  factory SettingModel.init() => SettingModel(
        language: AppLocaleUtils.findDeviceLocale().name,
        developerOption: false,
      );

  SettingModel copyWith({
    String? language,
    bool? developerOption,
  }) =>
      SettingModel(
        id: id,
        language: language ?? this.language,
        developerOption: developerOption ?? this.developerOption,
      );
}
