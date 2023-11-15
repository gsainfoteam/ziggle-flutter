import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/user_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenRepository _storage;
  final UserRepository _repository;
  final AnalyticsRepository _analytics;
  final AuthRepository _authRepository;
  bool _isAnonymous = false;

  AuthBloc(
    this._storage,
    this._repository,
    this._analytics,
    this._authRepository,
  ) : super(const AuthState.initial()) {
    on<_Load>(_load);
    on<_Login>(_login);
    on<_LoginAnonymous>(_loginAnonymous);
    on<_Logout>(_logout);
  }

  FutureOr<void> _logout(_Logout event, Emitter<AuthState> emit) {
    _authRepository.setRecentLogout();
    if (_isAnonymous) {
      _analytics.logLogoutAnonymous();
    } else {
      _analytics.logLogout();
    }
    _isAnonymous = false;
    _storage.delete();
  }

  FutureOr<void> _loginAnonymous(
    _LoginAnonymous event,
    Emitter<AuthState> emit,
  ) {
    _analytics.logLoginAnonymous();
    _isAnonymous = true;
    emit(const AuthState.anonymous());
  }

  FutureOr<void> _login(_Login event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    _analytics.logTryLogin();
    try {
      final user = await _repository.login();
      _analytics.logLogin();
      return emit(AuthState.authenticated(user));
    } catch (e) {
      _analytics.logLoginCancel(e.toString());
      return emit(AuthState.error(e.toString()));
    }
  }

  FutureOr<void> _load(_Load event, Emitter<AuthState> emit) async {
    return emit.forEach(
      _storage.read().asyncMap((token) async {
        if (_isAnonymous) return const AuthState.anonymous();
        try {
          if (token == null) return const AuthState.unauthenticated();
          final user = await _repository.userInfo();
          if (user == null) return const AuthState.unauthenticated();
          return AuthState.authenticated(user);
        } catch (_) {
          return const AuthState.unauthenticated();
        }
      }),
      onData: (state) => state,
    );
  }
}

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.loginAnonymous() = _LoginAnonymous;
  const factory AuthEvent.login() = _Login;
  const factory AuthEvent.logout() = _Logout;
}

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.anonymous() = _Anonymous;
  const factory AuthState.error(String message) = _Error;

  bool get isLoggined => maybeMap(
        authenticated: (_) => true,
        anonymous: (_) => true,
        orElse: () => false,
      );

  UserEntity? get user => maybeMap(
        authenticated: (s) => s.user,
        orElse: () => null,
      );
}
