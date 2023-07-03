import 'package:dio/dio.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';
import 'package:ziggle/app/data/provider/api.dart';

class WrongAuthCodeException implements Exception {}

class UserRepository {
  final ApiProvider _provider;

  UserRepository(this._provider);

  Future<String> loginWithCode(String code) async {
    try {
      final result = await _provider.login(code);
      return result.jwtToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongAuthCodeException();
      } else {
        rethrow;
      }
    }
  }

  Future<UserInfoResponse> userInfo(String userUuid) =>
      _provider.userInfo(userUuid);
}
