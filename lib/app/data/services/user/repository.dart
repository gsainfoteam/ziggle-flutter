import 'package:ziggle/app/data/provider/api.dart';

class WrongAuthCodeException implements Exception {}

class UserRepository {
  final ApiProvider _provider;

  UserRepository(this._provider);

  Future updateFcmToken(String fcmToken) => _provider.updateFcmToken(fcmToken);
}
