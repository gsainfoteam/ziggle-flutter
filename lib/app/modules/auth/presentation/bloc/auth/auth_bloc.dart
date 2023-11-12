import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/user_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenRepository _storage;
  final UserRepository _repository;

  AuthBloc(this._storage, this._repository) : super(const AuthState.initial()) {
    on<_Load>((event, emit) async {
      emit(const AuthState.loading());
      return emit.forEach(
        _storage.read().asyncMap((token) async {
          if (token == null) return const AuthState.unauthenticated();
          final user = await _repository.userInfo();
          if (user == null) return const AuthState.unauthenticated();
          return AuthState.authenticated(user);
        }),
        onData: (state) => state,
      );
    });
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
}

@freezed
class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;

  UserEntity? get user => maybeMap(
        authenticated: (s) => s.user,
        orElse: () => null,
      );
}
