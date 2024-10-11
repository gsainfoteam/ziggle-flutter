import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Strings {
  Strings._();

  static final amplitudeApiKey = dotenv.get('AMPLITUDE_API_KEY');
  static final smartlookApiKey = dotenv.get('SMARTLOOK_API_KEY');

  static final idpRedirectScheme = dotenv.get('IDP_REDIRECT_SCHEME');
  static final idpBaseUrl = dotenv.get('IDP_BASE_URL');
  static final ziggleIdpClientId = dotenv.get('ZIGGLE_IDP_CLIENT_ID');
  static final groupsIdpClientId = dotenv.get('GROUPS_IDP_CLIENT_ID');
  static final ziggleIdpPath = dotenv.get('ZIGGLE_IDP_PATH');
  static final ziggleReLoginIdpPath = dotenv.get('ZIGGLE_IDP_RE_LOGIN_PATH');
  static final groupsIdpPath = dotenv.get('GROUPS_IDP_PATH');
  static final groupsIdpReLoginPath = dotenv.get('GROUPS_IDP_RE_LOGIN_PATH');
  static final privacyPolicyUrl = dotenv.get('PRIVACY_POLICY_URL');
  static final termsOfServiceUrl = dotenv.get('TERMS_OF_SERVICE_URL');
  static final withdrawalUrl = dotenv.get('WITHDRAWAL_URL');
  static final heyDeveloperUrl = dotenv.get('HEY_DEVELOPER_URL');
}
