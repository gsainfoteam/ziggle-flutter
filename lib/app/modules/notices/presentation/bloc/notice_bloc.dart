import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

part 'notice_bloc.freezed.dart';

@injectable
class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository _repository;

  NoticeBloc(this._repository, @factoryParam NoticeEntity notice)
      : super(_Initial(notice)) {
    on<_Load>((event, emit) async {
      emit(_Loading(event.notice));
      final data = await _repository.getNotice(event.notice.id);
      emit(_Loaded(data));
    });
    on<_Refresh>((event, emit) async {
      emit(_Loading(state.notice));
      final data = await _repository.getNotice(state.notice.id);
      emit(_Loaded(data));
    });
    on<_AddReaction>((event, emit) async {
      emit(_Loading(state.notice));
      final data = await _repository.addReaction(state.notice.id, event.emoji);
      emit(_Loaded(data));
    });
    on<_RemoveReaction>((event, emit) async {
      emit(_Loading(state.notice));
      final data =
          await _repository.removeReaction(state.notice.id, event.emoji);
      emit(_Loaded(data));
    });
  }
}

@freezed
class NoticeEvent with _$NoticeEvent {
  const factory NoticeEvent.load(NoticeEntity notice) = _Load;
  const factory NoticeEvent.refresh() = _Refresh;
  const factory NoticeEvent.addReaction(String emoji) = _AddReaction;
  const factory NoticeEvent.removeReaction(String emoji) = _RemoveReaction;
}

@freezed
class NoticeState with _$NoticeState {
  const NoticeState._();
  const factory NoticeState.initial(NoticeEntity notice) = _Initial;
  const factory NoticeState.loading(NoticeEntity notice) = _Loading;
  const factory NoticeState.loaded(NoticeEntity notice) = _Loaded;

  bool get loaded => this is _Loaded;
}
