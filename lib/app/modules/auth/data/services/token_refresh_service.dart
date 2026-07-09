import 'package:mutex/mutex.dart';

abstract class TokenRefreshService {
  ReadWriteMutex get mutex;
  Future<bool> refresh();
}
