import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/values/strings.dart';

import '../../../core/domain/repositories/api_channel_repository.dart';
import '../../domain/entities/oauth_entity.dart';
import '../../domain/repositories/oauth_repository.dart';

class InvalidAuthorizationCodeException implements Exception {}

@Singleton(as: OAuthRepository)
class WebAuth2AOuthRepository implements OAuthRepository {
  final ApiChannelRepository _channelRepository;
  bool _recentLogout = false;
  String get _idpBaseUrl => _channelRepository.idpUrl;
  String get _path => _recentLogout ? Strings.reloginIdpPath : Strings.idpPath;

  WebAuth2AOuthRepository(this._channelRepository);

  @override
  Future<OAuthEntity> getAuthorizationCode() async {
    final result = await FlutterWebAuth2.authenticate(
      url: '$_idpBaseUrl$_path',
      callbackUrlScheme: Strings.idpRedirectScheme,
    );
    final uri = Uri.parse(result);
    final authCode = uri.queryParameters['code'];
    if (authCode == null) throw InvalidAuthorizationCodeException();
    return OAuthEntity(authCode);
  }

  @override
  Future<void> setRecentLogout([bool value = true]) async {
    _recentLogout = value;
  }
}
