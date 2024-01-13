import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/common/domain/repositories/deep_link_repository.dart';
import 'package:ziggle/app/common/domain/repositories/messaging_repository.dart';

part 'link_bloc.freezed.dart';

@injectable
class LinkBloc extends Bloc<LinkEvent, LinkState> {
  final MessagingRepository _repository;
  final DeepLinkRepository _deepLinkRepository;

  LinkBloc(
    this._repository,
    this._deepLinkRepository,
  ) : super(const LinkState.initial()) {
    on<_Init>(_init);
  }

  FutureOr<void> _init(_Init event, Emitter<LinkState> emit) {
    return emit.forEach(
      MergeStream([_deepLinkRepository.getLink(), _repository.getLink()]),
      onData: LinkState.link,
    );
  }
}

@freezed
sealed class LinkEvent with _$LinkEvent {
  const factory LinkEvent.init() = _Init;
}

@freezed
sealed class LinkState with _$LinkState {
  const factory LinkState.initial() = _Initial;
  const factory LinkState.link(String link) = _Link;
}
