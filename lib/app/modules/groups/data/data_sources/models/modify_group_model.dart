import 'package:freezed_annotation/freezed_annotation.dart';

part 'modify_group_model.freezed.dart';
part 'modify_group_model.g.dart';

@freezed
class ModifyGroupModel with _$ModifyGroupModel {
  factory ModifyGroupModel({
    String? name,
    String? description,
    String? notionPageId,
  }) = _ModifyGroupModel;

  factory ModifyGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ModifyGroupModelFromJson(json);
}

extension ModifyGroupModelX on ModifyGroupModel {
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (description != null) json['description'] = description;
    if (notionPageId != null) json['notionPageId'] = notionPageId;
    return json;
  }
}
