import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_existence_model.freezed.dart';
part 'group_existence_model.g.dart';

@freezed
sealed class GroupExistenceModel with _$GroupExistenceModel {
  const factory GroupExistenceModel({
    required bool exist,
  }) = _GroupExistenceModel;

  factory GroupExistenceModel.fromJson(Map<String, dynamic> json) =>
      _$GroupExistenceModelFromJson(json);
}
