import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_request_model.freezed.dart';
part 'token_request_model.g.dart';

@freezed
sealed class TokenRequestModel with _$TokenRequestModel {
  const factory TokenRequestModel({
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'redirect_uri') required String redirectUri,
  }) = _TokenRequestModel;

  factory TokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TokenRequestModelFromJson(json);
}
