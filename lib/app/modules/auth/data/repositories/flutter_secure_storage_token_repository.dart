import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/token_repository.dart';

@LazySingleton(as: TokenRepository)
class FlutterSecureStorageTokenRepository implements TokenRepository {
  final FlutterSecureStorage _storage;
  static const _tokenKey = '_token';
  static const _expiredAtKey = '_expiredAt';
  final _tokenController = StreamController<String?>.broadcast();

  FlutterSecureStorageTokenRepository(this._storage);

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    _tokenController.add(null);
  }

  @override
  Future<bool> hasToken() async {
    final contains = await _storage.containsKey(key: _tokenKey);
    return contains;
  }

  @override
  Future<void> saveToken(String token, int expiresIn) async {
    await _storage.write(key: _tokenKey, value: token);
    final expiredAt = DateTime.now().add(Duration(seconds: expiresIn));
    await _storage.write(
      key: _expiredAtKey,
      value: expiredAt.toIso8601String(),
    );
    _tokenController.add(token);
  }

  @override
  Stream<String?> get token async* {
    final token = await _storage.read(key: _tokenKey);
    yield token;
    yield* _tokenController.stream;
  }

  @override
  Future<bool> hasExpired() async {
    final expiredAt = await _storage.read(key: _expiredAtKey);
    if (expiredAt == null) return true;
    final parsed = DateTime.parse(expiredAt);
    return parsed.isBefore(DateTime.now());
  }
}
