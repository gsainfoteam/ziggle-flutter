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
  /// 서버가 미동의 유저에게 내려주는 메시지.
  /// `UnauthorizedException('Consent required')` -> 401 + {"message": "Consent required"}
  static const _consentRequiredMessage = 'consent required';

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
      await refetchMe();
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
    } on DioException catch (e) {
      // 로그인은 되었으나 아직 약관에 동의하지 않은 상태.
      // 프로필이 없을 뿐 인증은 유효하므로 동의 화면으로 넘겨야 한다.
      if (_isConsentRequired(e)) {
        _subject.add(null);
        return null;
      }
      // 네트워크 오류 등 일시적인 실패를 미동의로 오해하지 않는다.
      // 이미 받아둔 정보가 있으면 유지하고, 없으면(최초 구동) 비로그인으로 둔다.
      if (!_subject.hasValue) _subject.add(null);
      return _subject.value;
    }
  }

  bool _isConsentRequired(DioException e) {
    if (e.response?.statusCode != 401) return false;
    final message = switch (e.response?.data) {
      {'message': final String m} => m,
      _ => null,
    };
    return message?.trim().toLowerCase() == _consentRequiredMessage;
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
