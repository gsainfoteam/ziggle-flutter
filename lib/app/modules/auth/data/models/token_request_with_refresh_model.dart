import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_request_with_refresh_model.freezed.dart';
part 'token_request_with_refresh_model.g.dart';

@freezed
class TokenRequestWithRefreshModel with _$TokenRequestWithRefreshModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TokenRequestWithRefreshModel({
    @Default('refresh_token') String grantType,
    required String refreshToken,
    required String clientId,
  }) = _TokenRequestWithRefreshModel;

  factory TokenRequestWithRefreshModel.fromJson(Map<String, dynamic> json) =>
      _$TokenRequestWithRefreshModelFromJson(json);
}
