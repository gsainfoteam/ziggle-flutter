import 'package:dio/dio.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';
import 'package:ziggle/app/data/provider/api.dart';
import 'package:ziggle/app/data/provider/db.dart';

const _recentLogoutKey = 'recentLogout';

class WrongAuthCodeException implements Exception {}

class UserRepository {
  final ApiProvider _provider;
  final DbProvider _dbProvider;

  UserRepository(this._provider, this._dbProvider);

  Future<String> loginWithCode(String code) async {
    try {
      final result = await _provider.login(code);
      return result.accessToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongAuthCodeException();
      }
      rethrow;
    }
  }

  Future<UserInfoResponse> userInfo() => _provider.userInfo();

  Future updateFcmToken(String fcmToken) => _provider.updateFcmToken(fcmToken);

  bool get recentLogout => _dbProvider.getSetting(_recentLogoutKey) ?? false;

  Future<void> setRecentLogout([bool value = true]) {
    return _dbProvider.setSetting(_recentLogoutKey, value);
  }
}
