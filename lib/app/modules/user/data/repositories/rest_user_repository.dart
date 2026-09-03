import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/user_api.dart';
import 'package:ziggle/app/modules/user/data/models/user_model.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/domain/repositories/user_repository.dart';

@Singleton(as: UserRepository, dispose: RestUserRepository.dispose)
class RestUserRepository implements UserRepository {
  final UserApi _api;
  final AuthRepository _authRepository;
  final _subject = BehaviorSubject<UserModel?>();

  static void dispose(UserRepository inst) {
    final instance = inst as RestUserRepository;
    instance._subject.close();
  }

  RestUserRepository(this._api, this._authRepository) {
    _authRepository.isSignedIn.listen((signedIn) async {
      if (!signedIn) {
        _subject.add(null);
        return;
      }
      try {
        final user = await _api.info();
        _subject.add(user);
      } on DioException catch (e) {
        // 여기로 왔다는 건 로그인은 됐는데, 에러가 떴다는 말임.
        // 이때 에러가 consent가 없는 에러인 경우에만 예외 처리를 해줘야 함.
        if (e.response?.data['message'] == "Consent required") {
          const noConsent = UserModel(
            email: 'noconsent',
            name: 'noconsent',
            uuid: 'noconsent',
          );
          _subject.add(noConsent);
        } else {
          _subject.add(null);
        }
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

  @override
  Future<void> consent() async {
    await _api.consent();
  }

  @override
  Future<void> withdraw() async {
    await _api.withdraw();
  }
}
