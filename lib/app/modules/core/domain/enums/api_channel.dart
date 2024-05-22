import 'package:flutter/foundation.dart';

enum ApiChannel {
  staging(
    'https://api.stg.ziggle.gistory.me/',
    'https://stg.idp.gistory.me',
    'ziggle_stg',
  ),
  production(
    'https://api.ziggle.gistory.me/',
    'https://idp.gistory.me',
    'ziggle2023',
  );

  final String baseUrl;
  final String idpBaseUrl;
  final String idpClientId;
  const ApiChannel(this.baseUrl, this.idpBaseUrl, this.idpClientId);

  factory ApiChannel.byMode() => kDebugMode ? staging : production;
  ApiChannel get oppose => this == staging ? production : staging;
}
