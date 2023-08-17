import 'package:flutter/foundation.dart';

enum ApiChannel {
  staging(
      'https://api.stg.ziggle.gistory.me', 'https://stg.new-idp.gistory.me'),
  production('https://api.ziggle.gistory.me', 'https://idp.gistory.me');

  final String baseUrl;
  final String idpBaseUrl;
  const ApiChannel(this.baseUrl, this.idpBaseUrl);

  static ApiChannel get byMode => kDebugMode ? staging : production;
  ApiChannel get oppose => this == staging ? production : staging;
}
