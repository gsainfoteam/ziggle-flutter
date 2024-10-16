import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/repositories/web_auth_2_oauth_repository.dart';
import 'package:ziggle/app/values/strings.dart';

@Singleton()
class GroupsWebAuth2OauthRepository extends WebAuth2OAuthRepository {
  @override
  String get path =>
      recentLogout ? Strings.groupsIdpReLoginPath : Strings.groupsIdpPath;
}
