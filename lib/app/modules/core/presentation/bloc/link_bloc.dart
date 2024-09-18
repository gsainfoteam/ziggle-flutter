import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/repositories/link_repository.dart';

part 'link_bloc.freezed.dart';

@injectable
class LinkBloc extends Bloc<LinkEvent, LinkState> {
  final LinkRepository _repository;

  LinkBloc(this._repository) : super(const LinkState.initial()) {
    on<_Init>((event, emit) {
      emit(const LinkState.loading());
      return emit.forEach(
        _repository.getLinkStream().expand((event) => [event, null]),
        onData: (state) => state != null ? _Loaded(state) : const _Initial(),
        onError: (error, _) => const _Error(),
      );
    });
  }
}

@freezed
class LinkEvent with _$LinkEvent {
  const factory LinkEvent.init() = _Init;
}

@freezed
class LinkState with _$LinkState {
  const factory LinkState.initial() = _Initial;
  const factory LinkState.loading() = _Loading;
  const factory LinkState.loaded(String link) = _Loaded;
  const factory LinkState.error() = _Error;
}
