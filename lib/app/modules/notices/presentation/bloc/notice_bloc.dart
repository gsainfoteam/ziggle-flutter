import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';

part 'notice_bloc.freezed.dart';

@injectable
class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository _repository;

  NoticeBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(_Loaded(event.entity));
      emit(_Loaded(await _repository.getNotice(event.entity.id)));
    });
    on<_SendNotification>((event, emit) async {
      if (state.entity == null) return;
      emit(_Loading(state.entity!.copyWith(publishedAt: DateTime.now())));
      sl<AnalyticsRepository>().logEvent(
        EventType.action,
        AnalyticsEvent.noticeSendNotification(state.entity!.id),
      );
      final entity = await _repository.sendNotification(state.entity!.id);
      emit(_Loaded(entity));
    });
    on<_Delete>((event, emit) async {
      if (state.entity == null) return;
      emit(_Loading(state.entity!));
      sl<AnalyticsRepository>().logEvent(
        EventType.action,
        AnalyticsEvent.noticeDelete(state.entity!.id),
      );
      await _repository.deleteNotice(state.entity!.id);
      emit(const _Deleted());
    });
    on<_AddReaction>((event, emit) async {
      if (state.entity == null) return;
      emit(_Loaded(state.entity!.addReaction(event.reaction)));
      await _repository.addReaction(state.entity!.id, event.reaction.emoji);
      emit(_Loaded(await _repository.getNotice(state.entity!.id)));
    });
    on<_RemoveReaction>((event, emit) async {
      if (state.entity == null) return;
      emit(_Loaded(state.entity!.removeReaction(event.reaction)));
      await _repository.removeReaction(state.entity!.id, event.reaction.emoji);
      emit(_Loaded(await _repository.getNotice(state.entity!.id)));
    });
    on<_GetFull>((event, emit) async {
      if (state.entity == null) return;
      emit(_Loading(state.entity!));
      final notice = await _repository.getNotice(state.entity!.id, true);
      emit(_Loaded(notice));
    });
  }
}

@freezed
sealed class NoticeEvent with _$NoticeEvent {
  const factory NoticeEvent.load(NoticeEntity entity) = _Load;
  const factory NoticeEvent.sendNotification() = _SendNotification;
  const factory NoticeEvent.delete() = _Delete;
  const factory NoticeEvent.addReaction(NoticeReaction reaction) = _AddReaction;
  const factory NoticeEvent.removeReaction(NoticeReaction reaction) =
      _RemoveReaction;
  const factory NoticeEvent.getFull() = _GetFull;
}

@freezed
sealed class NoticeState with _$NoticeState {
  const NoticeState._();
  const factory NoticeState.initial() = _Initial;
  const factory NoticeState.loaded(NoticeEntity entity) = _Loaded;
  const factory NoticeState.loading(NoticeEntity entity) = _Loading;
  const factory NoticeState.deleted() = _Deleted;

  NoticeEntity? get entity => mapOrNull(loaded: (state) => state.entity);
  bool get isLoaded => this is _Loaded;
  bool get isDeleted => this is _Deleted;
}
