import 'package:flutter/foundation.dart';

enum ApiChannel {
  staging('https://api.stg.ziggle.gistory.me/'),
  production('https://api.ziggle.gistory.me/');

  final String baseUrl;
  const ApiChannel(this.baseUrl);

  factory ApiChannel.byMode() => kDebugMode ? staging : production;
  ApiChannel get oppose => this == staging ? production : staging;
}
