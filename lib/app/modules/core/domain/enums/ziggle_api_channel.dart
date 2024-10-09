import 'package:flutter/foundation.dart';

enum ZiggleApiChannel {
  staging('https://api.stg.ziggle.gistory.me/'),
  production('https://api.ziggle.gistory.me/');

  final String baseUrl;
  const ZiggleApiChannel(this.baseUrl);

  factory ZiggleApiChannel.byMode() => kDebugMode ? staging : production;
  ZiggleApiChannel get oppose => this == staging ? production : staging;
}
