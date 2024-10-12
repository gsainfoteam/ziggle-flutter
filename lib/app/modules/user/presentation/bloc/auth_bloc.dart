import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/enums/page_source.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_rest_auth_repository.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RestAuthRepository _repository;
  final AnalyticsRepository _analyticsRepository;

  AuthBloc(
    @Named.from(ZiggleRestAuthRepository) this._repository,
    this._analyticsRepository,
  ) : super(const AuthState.initial()) {
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
        _analyticsRepository.logEvent(
          EventType.action,
          AnalyticsEvent.profileLogin(event.source),
        );
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
    on<_Logout>((event, emit) async {
      _analyticsRepository.logEvent(
          EventType.action, AnalyticsEvent.profileLogout(event.source));
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
  const factory AuthEvent.login({required PageSource source}) = _Login;
  const factory AuthEvent.logout({required PageSource source}) = _Logout;
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
  bool get hasError => this is _Error;
}
