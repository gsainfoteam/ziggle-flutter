import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/push_message_repository.dart';

part 'push_message_bloc.freezed.dart';

@singleton
class PushMessageBloc extends Bloc<PushMessageEvent, PushMessageState> {
  final PushMessageRepository _repository;

  PushMessageBloc(this._repository) : super(const _Initial()) {
    on<_Init>((event, emit) async {
      emit(const _Loading());
      return emit.forEach(
        _repository.getTokenStream(),
        onData: (token) => PushMessageState.loaded(token),
        onError: (error, _) => PushMessageState.error(error.toString()),
      );
    });
    on<_Reset>((event, emit) async {
      emit(const _Loading());
      await _repository.clearToken();
    });
  }
}

@freezed
class PushMessageEvent with _$PushMessageEvent {
  const factory PushMessageEvent.init() = _Init;
  const factory PushMessageEvent.reset() = _Reset;
}

@freezed
class PushMessageState with _$PushMessageState {
  const factory PushMessageState.initial() = _Initial;
  const factory PushMessageState.loading() = _Loading;
  const factory PushMessageState.error(String message) = _Error;
  const factory PushMessageState.loaded(String token) = _Loaded;
}
