import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_president_model.freezed.dart';
part 'update_president_model.g.dart';

@freezed
sealed class UpdatePresidentModel with _$UpdatePresidentModel {
  factory UpdatePresidentModel(
    String newPresidentUuid,
  ) = _UpdatePresidentModel;

  factory UpdatePresidentModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePresidentModelFromJson(json);
}
