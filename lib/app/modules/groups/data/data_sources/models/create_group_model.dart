import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_group_model.freezed.dart';

@freezed
sealed class CreateGroupModel with _$CreateGroupModel {
  const factory CreateGroupModel({
    required String name,
    required String description,
    required String notionPageId,
  }) = _CreateGroupModel;

  factory CreateGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupModelFromJson(json);
}
