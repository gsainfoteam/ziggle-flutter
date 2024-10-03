abstract class Strings {
  Strings._();

  static const amplitudeApiKey = '--REDACTED--';
  static const smartlookApiKey = '--REDACTED--';
  static const idpRedirectScheme = 'ziggle-idp-login-redirect';
  static const idpBaseUrl = 'https://idp.gistory.me';
  static const idpClientId = 'ziggle2023';
  static String get _idpBasePath => '/authorize'
      '?client_id=$idpClientId'
      '&redirect_uri=$idpRedirectScheme://callback'
      '&scope=openid%20profile%20email%20student_id%20offline_access'
      '&response_type=code';
  static String get idpPath => '$_idpBasePath&prompt=consent';
  static String get reLoginIdpPath => '$_idpBasePath&prompt=login';
  static const privacyPolicyUrl =
      'https://infoteam-rulrudino.notion.site/ceb9340c0b514497b6d916c4a67590a1';
  static const termsOfServiceUrl =
      'https://infoteam-rulrudino.notion.site/6177be6369e44280a23a65866c51b257';
  static const withdrawalUrl = 'https://idp.gistory.me';

  static const heyDeveloperUrl = 'https://cs.gistory.me/?service=Ziggle';
}
