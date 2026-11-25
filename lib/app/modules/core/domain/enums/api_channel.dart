import 'package:flutter/foundation.dart';

enum ApiChannel {
  staging('https://api.stg.ziggle.gistory.me/'),
  production('https://api.ziggle.gistory.me/');

  final String ziggleBaseUrl;
  const ApiChannel(this.ziggleBaseUrl);

  /// `--dart-define=ZIGGLE_API_CHANNEL=staging` 처럼 빌드할 때 정한 채널.
  /// E2E 빌드는 빌드 모드와 관계없이 스테이징 API를 써야 하므로 명시한다.
  static const _defined = String.fromEnvironment('ZIGGLE_API_CHANNEL');

  factory ApiChannel.byMode() => switch (_defined) {
    'staging' => staging,
    'production' => production,
    '' => kDebugMode ? staging : production,
    _ => throw ArgumentError.value(
      _defined,
      'ZIGGLE_API_CHANNEL',
      'must be "staging" or "production"',
    ),
  };
  ApiChannel get oppose => this == staging ? production : staging;
}
