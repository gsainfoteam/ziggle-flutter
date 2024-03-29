import 'package:flutter/foundation.dart';

enum ApiChannel {
  staging(
      'https://api.stg.ziggle.gistory.me/v3/', 'https://stg.idp.gistory.me'),
  production('https://api.ziggle.gistory.me/v3/', 'https://idp.gistory.me');

  final String baseUrl;
  final String idpBaseUrl;
  const ApiChannel(this.baseUrl, this.idpBaseUrl);

  factory ApiChannel.byMode() => kDebugMode ? staging : production;
  ApiChannel get oppose => this == staging ? production : staging;
}
