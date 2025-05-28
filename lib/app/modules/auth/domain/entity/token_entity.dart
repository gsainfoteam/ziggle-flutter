class TokenEntity {
  final String accessToken;
  final String? refreshToken;

  TokenEntity({
    required this.accessToken,
    required this.refreshToken,
  });
}
