abstract class Strings {
  Strings._();

  static const _idpClientId = 'ziggle2023';
  static const idpRedirectScheme = 'ziggle-idp-login-redirect';
  static const _idpBasePath = '/authorize'
      '?client_id=$_idpClientId'
      '&redirect_uri=$idpRedirectScheme://callback'
      '&scope=openid%20profile%20email%20student_id%20offline_access'
      '&response_type=code';
  static const idpPath = '$_idpBasePath&prompt=consent';
  static const reloginIdpPath = '$_idpBasePath&prompt=login';
  static const privacyPolicyUrl =
      'https://infoteam-rulrudino.notion.site/ceb9340c0b514497b6d916c4a67590a1';
  static const termsOfServiceUrl =
      'https://infoteam-rulrudino.notion.site/6177be6369e44280a23a65866c51b257';
  static const withdrawalUrl = 'https://idp.gistory.me';

  static const smartlookKey = '559177df225fb6be8f57ab026bcd071f18c172cc';
}
