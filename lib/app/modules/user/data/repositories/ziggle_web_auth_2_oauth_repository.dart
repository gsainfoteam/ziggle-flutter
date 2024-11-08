import 'package:injectable/injectable.dart';

import '../../../../values/strings.dart';
import 'web_auth_2_oauth_repository.dart';

@named
@Singleton(as: WebAuth2OAuthRepository)
class ZiggleWebAuth2OauthRepository extends WebAuth2OAuthRepository {
  @override
  String get path =>
      recentLogout ? Strings.ziggleIdpReLoginPath : Strings.ziggleIdpPath;
}
