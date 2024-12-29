import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_invite_code_request_model.freezed.dart';
part 'group_invite_code_request_model.g.dart';

@freezed
class GroupInviteCodeRequestModel with _$GroupInviteCodeRequestModel {
  factory GroupInviteCodeRequestModel({required int duration}) =
      _GroupInviteCodeRequestModel;

  factory GroupInviteCodeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GroupInviteCodeRequestModelFromJson(json);
}
