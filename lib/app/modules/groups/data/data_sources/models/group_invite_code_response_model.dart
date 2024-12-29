import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_invite_code_response_model.freezed.dart';
part 'group_invite_code_response_model.g.dart';

@freezed
class GroupInviteCodeResponseModel with _$GroupInviteCodeResponseModel {
  factory GroupInviteCodeResponseModel({required String code}) =
      _GroupInviteCodeResponseModel;

  factory GroupInviteCodeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupInviteCodeResponseModelFromJson(json);
}
