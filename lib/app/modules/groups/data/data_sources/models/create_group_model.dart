import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_group_model.freezed.dart';
part 'create_group_model.g.dart';

@freezed
sealed class CreateGroupModel with _$CreateGroupModel {
  const factory CreateGroupModel({
    required String name,
    required String description,
    String? notionPageId,
  }) = _CreateGroupModel;

  factory CreateGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupModelFromJson(json);
}
