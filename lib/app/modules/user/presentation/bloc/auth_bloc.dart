import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/domain/repositories/auth_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<_Load>((event, emit) async {
      emit(const _Loading());
      return emit.forEach(
        _repository.isSignedIn,
        onData: (v) => v ? const _Authenticated() : const _Unauthenticated(),
      );
    });
    on<_Login>((event, emit) async {
      emit(const _Loading());
      try {
        await _repository.login();
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
    on<_Logout>((event, emit) async {
      emit(const _Unauthenticated());
      await _repository.logout();
    });
  }

  static bool hasUser(BuildContext context) =>
      context.read<AuthBloc>().state.hasUser;
}

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.login() = _Login;
  const factory AuthEvent.logout() = _Logout;
}

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.error(String message) = _Error;

  bool get hasUser => this is _Authenticated;
  bool get isLoading => this is _Loading;
}
