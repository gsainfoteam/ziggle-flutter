import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/oauth_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final OAuthRepository _oAuthRepository;
  final AuthRepository _authRepository;

  AuthBloc(this._oAuthRepository, this._authRepository)
      : super(const _Initial()) {
    on<_Load>((event, emit) {
      emit(const _Loading());
      emit(const _Guest());
    });
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final data = await _oAuthRepository.getAuthorizationCode();
      final user = await _authRepository.login(data.authCode);
      emit(_Authenticated(user));
    });
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.login() = _Login;
}

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.guest() = _Guest;

  bool get isLoading => this is _Loading;
  UserEntity get user => (this as _Authenticated).user;
}
