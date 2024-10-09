import 'package:flutter/foundation.dart';

enum GroupsApiChannel {
  staging('https://api.stg.groups.gistory.me/'),
  production('https://api.groups.gistory.me/');

  final String baseUrl;
  const GroupsApiChannel(this.baseUrl);

  factory GroupsApiChannel.byMode() => kDebugMode ? staging : production;
  GroupsApiChannel get oppose => this == staging ? production : staging;
}
