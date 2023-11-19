import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/token_repository.dart';

@LazySingleton(as: TokenRepository)
class FlutterSecureStorageTokenRepository implements TokenRepository {
  final FlutterSecureStorage _storage;
  static const _tokenKey = '_token';
  final _tokenController = StreamController<String?>.broadcast();

  FlutterSecureStorageTokenRepository(this._storage);

  @override
  Future<void> delete() {
    _tokenController.add(null);
    return _storage.delete(key: _tokenKey);
  }

  @override
  Future<bool> hasToken() {
    return _storage.containsKey(key: _tokenKey);
  }

  @override
  Stream<String?> read() async* {
    yield await _storage.read(key: _tokenKey);
    yield* _tokenController.stream;
  }

  @override
  Future<void> save(String token) {
    _tokenController.add(token);
    return _storage.write(key: _tokenKey, value: token);
  }
}
