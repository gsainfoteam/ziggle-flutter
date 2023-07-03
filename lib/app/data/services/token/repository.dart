import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepository {
  final FlutterSecureStorage _storage;
  static const _key = 'access_token';

  final _controller = StreamController<String?>.broadcast();

  TokenRepository(this._storage);

  Future<void> deleteToken() async {
    await _storage.delete(key: _key);
    _controller.add(null);
  }

  Stream<String?> getToken() async* {
    yield await _storage.read(key: _key);
    yield* _controller.stream;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
    _controller.add(token);
  }
}
