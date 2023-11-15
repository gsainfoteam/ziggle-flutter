import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/messaging_repository.dart';

part 'messages_bloc.freezed.dart';

@injectable
class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessagingRepository _repository;

  MessagesBloc(this._repository) : super(const MessagesState.initial()) {
    on<_Init>(_init);
  }

  FutureOr<void> _init(_Init event, Emitter<MessagesState> emit) {
    return emit.forEach(
      _repository.getLink().expand((element) => [element, null]),
      onData: (link) => link == null
          ? const MessagesState.initial()
          : MessagesState.link(link),
    );
  }
}

@freezed
sealed class MessagesEvent with _$MessagesEvent {
  const factory MessagesEvent.init() = _Init;
}

@freezed
sealed class MessagesState with _$MessagesState {
  const factory MessagesState.initial() = _Initial;
  const factory MessagesState.link(String link) = _Link;
}
