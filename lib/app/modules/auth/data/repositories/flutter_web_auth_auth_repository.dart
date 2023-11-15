import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/api_channel_repository.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/modules/auth/domain/entities/auth_entity.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';

class InvalidAuthCodeException implements Exception {}

@Singleton(as: AuthRepository)
class FlutterWebAuthAuthRepository implements AuthRepository {
  final ApiChannelRepository _channel;
  var _recentLogout = false;

  FlutterWebAuthAuthRepository(this._channel);

  @override
  Future<AuthEntity> login() async {
    final result = await FlutterWebAuth2.authenticate(
      url: '${_channel.idpUrl}'
          '${_recentLogout ? reloginIdpPath : idpPath}',
      callbackUrlScheme: idpRedirectScheme,
    );
    final uri = Uri.parse(result);
    final authCode = uri.queryParameters['code'];
    if (authCode == null) throw InvalidAuthCodeException();
    return AuthEntity(authCode);
  }

  @override
  setRecentLogout([bool value = true]) {
    _recentLogout = value;
  }
}
