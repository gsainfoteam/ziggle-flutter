import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:nonce/nonce.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/oauth_api.dart';
import 'package:ziggle/app/modules/auth/data/models/token_request_with_code_model.dart';
import 'package:ziggle/app/modules/auth/domain/entity/token_entity.dart';
import 'package:ziggle/app/modules/user/domain/exceptions/invalid_authorization_state_exception.dart';
import 'package:ziggle/app/values/strings.dart';

import '../../../user/domain/exceptions/invalid_authorization_code_exception.dart';
import '../../domain/repositories/oauth_repository.dart';

abstract class WebAuth2OAuthRepository implements OAuthRepository {
  bool recentLogout = false;
  final String clientId;
  final OAuthApi _api;

  WebAuth2OAuthRepository(this._api, {required this.clientId});

  @override
  Future<TokenEntity> getToken() async {
    final state = Nonce.secure().toString();
    final codeVerifier = Nonce.secure().toString();
    final codeChallenge = base64Url
        .encode(sha256.convert(utf8.encode(codeVerifier)).bytes)
        .replaceAll('=', '');

    final scopes = [
      'profile',
      'email',
      'student_id',
      'offline_access',
    ];
    final prompt = recentLogout ? 'login' : 'consent';
    final url = '${Strings.idpBaseUrl}/authorize'
        '?client_id=$clientId'
        '&redirect_uri=${Strings.idPRedirectUri}'
        '&scope=${scopes.join('%20')}'
        '&response_type=code'
        '&state=$state'
        '&code_challenge=$codeChallenge'
        '&code_challenge_method=S256'
        '&prompt=$prompt';

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: Strings.idpRedirectScheme,
    );
    final uri = Uri.parse(result);

    final receivedState = uri.queryParameters['state'];
    if (receivedState != state) throw InvalidAuthorizationStateException();

    final authCode = uri.queryParameters['code'];
    if (authCode == null) throw InvalidAuthorizationCodeException();

    final res = await _api.getTokenFromCode(
      TokenRequestWithCodeModel(
        code: authCode,
        codeVerifier: codeVerifier,
        clientId: clientId,
      ),
    );
    return TokenEntity(
      accessToken: res.accessToken,
      refreshToken: res.refreshToken,
    );
  }

  @override
  Future<void> setRecentLogout([bool value = true]) async {
    recentLogout = value;
  }
}
