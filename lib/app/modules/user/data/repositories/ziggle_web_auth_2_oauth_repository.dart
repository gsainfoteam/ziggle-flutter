import 'package:injectable/injectable.dart';
import 'package:ziggle/app/values/strings.dart';

import '../../../auth/data/repositories/web_auth_2_oauth_repository.dart';

@named
@Singleton(as: WebAuth2OAuthRepository)
class ZiggleWebAuth2OauthRepository extends WebAuth2OAuthRepository {
  ZiggleWebAuth2OauthRepository(super.api)
      : super(clientId: Strings.ziggleIdpClientId);
}
