import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_response_model.freezed.dart';
part 'group_response_model.g.dart';

@freezed
class GroupResponseModel with _$GroupResponseModel {
  factory GroupResponseModel(
    String uuid,
    String name,
    String description,
    DateTime createdAt,
    String presidentUuid,
    int? memberCount,
    DateTime? verifiedAt,
    DateTime? deletedAt,
    String? notionPageId,
    String? profileImageKey,
  ) = _GroupResponseModel;

  factory GroupResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GroupResponseModelFromJson(json);
}
