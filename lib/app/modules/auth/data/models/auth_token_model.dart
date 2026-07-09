import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token_model.freezed.dart';
part 'auth_token_model.g.dart';

@freezed
sealed class AuthTokenModel with _$AuthTokenModel {
  const factory AuthTokenModel({
    @JsonKey(name: 'access_token') required String accessToken,
  }) = _AuthTokenModel;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);
}
