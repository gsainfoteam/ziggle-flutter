import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/repositories/web_auth_2_oauth_repository.dart';
import 'package:ziggle/app/values/strings.dart';

@named
@Singleton(as: WebAuth2OAuthRepository)
class GroupsWebAuth2OauthRepository extends WebAuth2OAuthRepository {
  GroupsWebAuth2OauthRepository(super.api)
      : super(clientId: Strings.groupsIdpClientId);
}
