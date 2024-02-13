import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';

import '../../data/models/notice_model.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

part 'notice_bloc.freezed.dart';

@injectable
class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository _repository;
  final AnalyticsRepository _analyticsRepository;

  NoticeBloc(
    this._repository,
    @factoryParam NoticeEntity notice,
    this._analyticsRepository,
  ) : super(_Initial(notice)) {
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
    on<_AddReminder>((event, emit) async {
      emit(_Loading(
        NoticeModel.fromEntity(state.notice).copyWith(isReminded: true),
      ));
      _analyticsRepository.logTryReminder();
      final data = await _repository.addReminder(state.notice.id);
      emit(_Loaded(data));
      _analyticsRepository.logToggleReminder(data.isReminded);
    });
    on<_RemoveReminder>((event, emit) async {
      emit(_Loading(
        NoticeModel.fromEntity(state.notice).copyWith(isReminded: false),
      ));
      _analyticsRepository.logTryReminder();
      final data = await _repository.removeReminder(state.notice.id);
      emit(_Loaded(data));
      _analyticsRepository.logToggleReminder(data.isReminded);
    });
    on<_Delete>((event, emit) async {
      emit(_Loading(state.notice));
      await _repository.deleteNotice(state.notice.id);
      emit(_Loaded(state.notice));
    });
    on<_Report>((event, emit) async {
      emit(_Loading(state.notice));
      _analyticsRepository.logTryReport();
      emit(_Loaded(state.notice));
      _analyticsRepository.logReport();
    });
  }
}

@freezed
class NoticeEvent with _$NoticeEvent {
  const factory NoticeEvent.load(NoticeEntity notice) = _Load;
  const factory NoticeEvent.refresh() = _Refresh;
  const factory NoticeEvent.addReaction(String emoji) = _AddReaction;
  const factory NoticeEvent.removeReaction(String emoji) = _RemoveReaction;
  const factory NoticeEvent.addReminder() = _AddReminder;
  const factory NoticeEvent.removeReminder() = _RemoveReminder;
  const factory NoticeEvent.delete() = _Delete;
  const factory NoticeEvent.report() = _Report;
}

@freezed
class NoticeState with _$NoticeState {
  const NoticeState._();
  const factory NoticeState.initial(NoticeEntity notice) = _Initial;
  const factory NoticeState.loading(NoticeEntity notice) = _Loading;
  const factory NoticeState.loaded(NoticeEntity notice) = _Loaded;

  bool get loaded => this is _Loaded;
}
