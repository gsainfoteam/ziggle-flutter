import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/data/models/user_model.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/user_repository.dart';

@Singleton(as: UserRepository, dispose: RestUserRepository.dispose)
class RestUserRepository implements UserRepository {
  final UserApi _api;
  final _subject = BehaviorSubject<UserModel?>();

  static dispose(UserRepository inst) {
    final instance = inst as RestUserRepository;
    instance._subject.close();
  }

  RestUserRepository(this._api, AuthRepository authRepository) {
    authRepository.isSignedIn.listen((signedIn) async {
      if (!signedIn) {
        _subject.add(null);
        return;
      }
      try {
        final user = await _api.info();
        _subject.add(user);
      } catch (_) {
        _subject.add(null);
      }
    });
  }

  @override
  Stream<UserModel?> get me => _subject.stream;

  @override
  Future<UserEntity?> refetchMe() async {
    try {
      final user = await _api.info();
      _subject.add(user);
      return user;
    } catch (_) {
      _subject.add(null);
      return null;
    }
  }
}
