import 'package:freezed_annotation/freezed_annotation.dart';

part 'notion_response_model.freezed.dart';

@freezed
class NotionResponseModel with _$NotionResponseModel {
  factory NotionResponseModel(Map<String, dynamic> content) =
      _NotionResponseModel;

  factory NotionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotionResponseModelFromJson(json);
}
