import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';
import 'package:ziggle/app/modules/user/domain/repositories/user_repository.dart';

part 'user_bloc.freezed.dart';

@singleton
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;
  final AnalyticsRepository _analyticsRepository;

  UserBloc(this._repository, this._analyticsRepository)
    : super(const _Initial()) {
    on<_Init>((event, emit) async {
      return emit.forEach(
        _repository.me,
        onData: (data) {
          _analyticsRepository.logChangeUser(data);
          return _Done(data);
        },
        onError: (_, _) => const _Initial(),
      );
    }, transformer: restartable());
    on<_Fetch>((event, emit) async {
      await _repository.refetchMe();
    });
    on<_Consent>((event, emit) async {
      await _repository.consent();
      await _repository.refetchMe();
    }, transformer: droppable());
    on<_Withdraw>((event, emit) async {
      await _repository.withdraw();
      // `initial`로 되돌리면 라우터 가드가 "아직 확인 전"으로 보고 이동을 막는다.
      // 탈퇴는 조회가 끝난 상태이므로 프로필만 비운다.
      emit(const _Done(null));
    }, transformer: droppable());
  }

  static UserEntity? userOrNull(BuildContext context) =>
      context.read<UserBloc>().state.user;
}

@freezed
sealed class UserEvent with _$UserEvent {
  const factory UserEvent.init() = _Init;
  const factory UserEvent.fetch() = _Fetch;
  const factory UserEvent.consent() = _Consent;
  const factory UserEvent.withdraw() = _Withdraw;
}

@freezed
sealed class UserState with _$UserState {
  const UserState._();

  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.done(UserEntity? user) = _Done;

  bool get isLoading => whenOrNull(loading: () => true) ?? false;

  /// 서버로부터 프로필 조회 결과를 한 번이라도 받았는지.
  /// `initial`(아직 모름)과 `done(null)`(미동의)을 구분하기 위해 필요하다.
  bool get isLoaded => this is _Done;
  UserEntity? get user => mapOrNull(done: (e) => e.user);
  bool get isConsent => user?.hasConsented ?? false;
}
