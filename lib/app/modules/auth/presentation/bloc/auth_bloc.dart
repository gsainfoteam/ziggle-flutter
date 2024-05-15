import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/oauth_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final OAuthRepository _oAuthRepository;
  final AuthRepository _authRepository;
  final AnalyticsRepository _analyticsRepository;

  String? _pushToken;

  AuthBloc(
    this._oAuthRepository,
    this._authRepository,
    this._analyticsRepository,
  ) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(const _Loading());
      await emit.forEach(
        _authRepository.user,
        onData: (user) => user == null ? const _Guest() : _Authenticated(user),
        onError: (_, __) => const _Guest(),
      );
    });
    on<_Login>((event, emit) async {
      _analyticsRepository.logTryLogin();
      emit(const _Loading());
      try {
        final data = await _oAuthRepository.getAuthorizationCode();
        final user = await _authRepository.login(data.authCode);
        emit(_Authenticated(user));
        _analyticsRepository.logLogin();
      } catch (e) {
        emit(_Error(e.toString()));
        _analyticsRepository.logLoginCancel(e.toString());
        rethrow;
      }
    });
    on<_Logout>((event, emit) async {
      emit(const _Loading());
      await _oAuthRepository.setRecentLogout();
      await _authRepository.logout();
      _authRepository.logout();
      emit(const _Guest());
    });
    on<_UpdatePushToken>((event, emit) async {
      _pushToken = event.token;
      await _authRepository.updatePushToken(event.token);
    });
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    _analyticsRepository.logChangeUser(change.nextState.userOrNull);
    switch (change.nextState) {
      case _Authenticated _:
        if (_pushToken != null) {
          _authRepository.updatePushToken(_pushToken!);
        }
        break;
    }
  }

  static UserEntity? userOrNull(BuildContext context) =>
      context.read<AuthBloc>().state.userOrNull;
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.login() = _Login;
  const factory AuthEvent.logout() = _Logout;
  const factory AuthEvent.updatePushToken(String token) = _UpdatePushToken;
}

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.guest() = _Guest;
  const factory AuthState.error(String message) = _Error;

  bool get isLoading => this is _Loading;
  UserEntity get user => (this as _Authenticated).user;
  UserEntity? get userOrNull =>
      maybeMap(authenticated: (s) => s.user, orElse: () => null);
  bool get hasUser => this is _Authenticated;
  bool get hasError => this is _Error;
  String get message => (this as _Error).message;
}
