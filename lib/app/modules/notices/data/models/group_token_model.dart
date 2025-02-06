import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_token_model.freezed.dart';
part 'group_token_model.g.dart';

@freezed
class GroupTokenModel with _$GroupTokenModel {
  const factory GroupTokenModel({
    required String groupsToken,
  }) = _GroupTokenModel;

  factory GroupTokenModel.fromJson(Map<String, dynamic> json) =>
      _$GroupTokenModelFromJson(json);
}
