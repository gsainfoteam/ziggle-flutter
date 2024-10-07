import 'package:flutter/foundation.dart';

enum ApiChannel {
  ziggleStaging('https://api.stg.ziggle.gistory.me/'),
  ziggleProduction('https://api.ziggle.gistory.me/'),
  groupsStaging('https://stg.api.groups.gistory.me/'),
  groupsProduction('https://api.groups.gistory.me/');

  final String baseUrl;
  const ApiChannel(this.baseUrl);

  static ApiChannel ziggleByMode() =>
      kDebugMode ? ApiChannel.ziggleStaging : ApiChannel.ziggleProduction;
  static ApiChannel groupsBymode() =>
      kDebugMode ? ApiChannel.groupsStaging : ApiChannel.groupsProduction;

  ApiChannel get oppose => this == ziggleStaging || this == ziggleProduction
      ? (this == ziggleStaging ? ziggleProduction : ziggleStaging)
      : (this == groupsStaging ? groupsProduction : groupsStaging);
}
