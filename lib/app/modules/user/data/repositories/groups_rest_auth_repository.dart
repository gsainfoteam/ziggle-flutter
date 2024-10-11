import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_web_auth_2_oauth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';

@Singleton()
class GroupsRestAuthRepository extends RestAuthRepository {
  GroupsRestAuthRepository(
      AuthApi api,
      GroupsFlutterSecureStorageTokenRepository tokenRepository,
      CookieManager cookieManager,
      GroupsWebAuth2OauthRepository oAuthRepository)
      : super(
            api: api,
            tokenRepository: tokenRepository,
            cookieManager: cookieManager,
            oAuthRepository: oAuthRepository);
}
