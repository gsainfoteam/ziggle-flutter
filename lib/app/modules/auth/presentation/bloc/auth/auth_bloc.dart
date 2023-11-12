import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/token_storage.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenStorage _storage;

  AuthBloc(this._storage) : super(const AuthState.initial()) {
    on<_Load>((event, emit) async {
      _storage.read();
    });
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
}
