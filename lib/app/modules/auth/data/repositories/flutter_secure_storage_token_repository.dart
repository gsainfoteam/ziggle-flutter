import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

abstract class FlutterSecureStorageTokenRepository implements TokenRepository {
  final FlutterSecureStorage _storage;
  final String _tokenKey;
  final String _expiredAtKey;
  final String _refreshTokenKey;
  final String _refreshTokenExpiredAtKey;

  final _subject = BehaviorSubject<String?>();
  final _expiredAtSubject = BehaviorSubject<DateTime?>();
  final _refreshTokenSubject = BehaviorSubject<String?>();
  final _refreshTokenExpiredAtSubject = BehaviorSubject<DateTime?>();

  FlutterSecureStorageTokenRepository({
    required FlutterSecureStorage storage,
    required String tokenKey,
    required String expiredAtKey,
    required String refreshTokenKey,
    required String refreshTokenExpiredAtKey,
  })  : _storage = storage,
        _tokenKey = tokenKey,
        _expiredAtKey = expiredAtKey,
        _refreshTokenKey = refreshTokenKey,
        _refreshTokenExpiredAtKey = refreshTokenExpiredAtKey;

  Future<void> init() async {
    await Future.wait([
      _storage.read(key: _tokenKey).then(_subject.add),
      _storage
          .read(key: _expiredAtKey)
          .then((v) => v == null ? null : DateTime.parse(v))
          .then(_expiredAtSubject.add),
      _storage.read(key: _refreshTokenKey).then(_refreshTokenSubject.add),
      _storage
          .read(key: _refreshTokenExpiredAtKey)
          .then((v) => v == null ? null : DateTime.parse(v))
          .then(_refreshTokenExpiredAtSubject.add),
    ]);
  }

  static FutureOr dispose(TokenRepository repository) {
    (repository as FlutterSecureStorageTokenRepository)
      .._subject.close()
      .._expiredAtSubject.close()
      .._refreshTokenSubject.close()
      .._refreshTokenExpiredAtSubject.close();
  }

  @override
  Stream<String?> get token => _subject.stream;

  @override
  Stream<String?> get refreshToken => _refreshTokenSubject.stream;

  @override
  Future<void> saveToken(String token,
      {Duration duration = const Duration(seconds: 3600)}) async {
    _subject.add(token);
    _expiredAtSubject.add(DateTime.now().add(duration));
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(
      key: _expiredAtKey,
      value: DateTime.now().add(duration).toIso8601String(),
    );
  }

  @override
  Future<void> saveRefreshToken(String token,
      {Duration duration = const Duration(days: 180)}) async {
    _refreshTokenSubject.add(token);
    _refreshTokenExpiredAtSubject.add(DateTime.now().add(duration));
    await _storage.write(key: _refreshTokenKey, value: token);
    await _storage.write(
      key: _refreshTokenExpiredAtKey,
      value: DateTime.now().add(duration).toIso8601String(),
    );
  }

  @override
  Future<void> deleteToken() async {
    _subject.add(null);
    _expiredAtSubject.add(null);
    _refreshTokenSubject.add(null);
    _refreshTokenExpiredAtSubject.add(null);
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _expiredAtKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _refreshTokenExpiredAtKey);
  }

  @override
  DateTime? get tokenExpiration => _expiredAtSubject.value;

  @override
  DateTime? get refreshTokenExpiration => _refreshTokenExpiredAtSubject.value;
}
