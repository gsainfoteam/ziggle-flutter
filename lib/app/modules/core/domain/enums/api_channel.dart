import 'package:flutter/foundation.dart';

enum ApiChannel {
  staging(
    'https://api.stg.ziggle.gistory.me/',
    'https://api.stg.groups.gistory.me/',
  ),
  production(
    'https://api.ziggle.gistory.me/',
    'https://api.groups.gistory.me/',
  );

  final String ziggleBaseUrl;
  final String groupsBaseUrl;
  const ApiChannel(this.ziggleBaseUrl, this.groupsBaseUrl);

  factory ApiChannel.byMode() => kDebugMode ? staging : production;
  ApiChannel get oppose => this == staging ? production : staging;
}
