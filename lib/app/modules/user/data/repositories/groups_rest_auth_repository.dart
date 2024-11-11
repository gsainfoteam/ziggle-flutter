import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/auth_api.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_web_auth_2_oauth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/web_auth_2_oauth_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/token_repository.dart';

@named
@Singleton(as: RestAuthRepository)
class GroupsRestAuthRepository extends RestAuthRepository {
  GroupsRestAuthRepository(
      AuthApi api,
      @Named.from(GroupsFlutterSecureStorageTokenRepository)
      TokenRepository tokenRepository,
      CookieManager cookieManager,
      @Named.from(GroupsWebAuth2OauthRepository)
      WebAuth2OAuthRepository oAuthRepository)
      : super(
            api: api,
            tokenRepository: tokenRepository,
            cookieManager: cookieManager,
            oAuthRepository: oAuthRepository);
}
