import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';

@Singleton(
  as: TokenRepository,
  dispose: FlutterSecureStorageTokenRepository.dispose,
)
class FlutterSecureStorageTokenRepository implements TokenRepository {
  final FlutterSecureStorage _storage;
  static const _tokenKey = '_token';
  final _subject = BehaviorSubject<String?>();

  FlutterSecureStorageTokenRepository(this._storage) {
    _storage.read(key: _tokenKey).then(_subject.add);
  }

  static FutureOr dispose(TokenRepository repository) {
    (repository as FlutterSecureStorageTokenRepository)._subject.close();
  }

  @override
  Stream<String?> get token => _subject.stream;

  @override
  Future<void> saveToken(String token,
      {Duration duration = const Duration(seconds: 3600)}) async {
    _subject.add(token);
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> deleteToken() async {
    _subject.add(null);
    await _storage.delete(key: _tokenKey);
  }

  @override
  DateTime? get tokenExpiration => throw UnimplementedError();
}
