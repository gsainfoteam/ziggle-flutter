import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

@freezed
class TokenModel with _$TokenModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TokenModel({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
    String? refreshToken,
    int? refreshTokenExpiresIn,
    String? idToken,
    required List<String> scope,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
}
