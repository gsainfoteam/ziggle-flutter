import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notices_repository.dart';

import '../../../domain/entities/notice_search_query_entity.dart';
import '../../../domain/entities/notice_summary_entity.dart';

part 'notices_bloc.freezed.dart';

const _throttleTime = Duration(milliseconds: 500);

@injectable
class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  final NoticesRepository _repository;

  NoticesBloc(this._repository) : super(const NoticesState.initial()) {
    on<_Fetch>(_fetch);
    on<_LoadMore>(
      _loadMore,
      transformer: (events, mapper) =>
          events.throttleTime(_throttleTime).switchMap(mapper),
    );
    on<_FetchOne>(_fetchOne);
    on<_Delete>(_delete);
  }

  FutureOr<void> _fetchOne(_FetchOne event, Emitter<NoticesState> emit) async {
    emit(NoticesState.loading([event.summary]));
    final notice = await _repository.getNotice(event.summary);
    emit(NoticesState.single(event.summary, notice));
  }

  FutureOr<void> _loadMore(_LoadMore event, Emitter<NoticesState> emit) async {
    final query = state.mapOrNull(loaded: (m) => m.lastQuery);
    if (query == null) return;
    if (!(state.mapOrNull(
          loaded: (m) => m.total > m.lastQuery.offset + m.lastQuery.limit,
        ) ??
        false)) return;
    final oldList = state.mapOrNull(loaded: (m) => m.notices) ?? [];
    emit(NoticesState.loading(oldList));
    final newQuery = query.copyWith(offset: query.offset + query.limit);
    final notices = await _repository.getNotices(newQuery);
    emit(NoticesState.loaded(
      [...oldList, ...notices.list],
      notices.total,
      newQuery,
    ));
  }

  FutureOr<void> _fetch(_Fetch event, Emitter<NoticesState> emit) async {
    emit(const NoticesState.loading());
    final notices = await _repository.getNotices(event.query);
    emit(NoticesState.loaded(
      notices.list,
      notices.total,
      event.query,
    ));
  }

  FutureOr<void> _delete(_Delete event, Emitter<NoticesState> emit) async {
    emit(NoticesState.loading([event.summary]));
    await _repository.deleteNotice(event.summary);
    emit(const NoticesState.initial());
  }
}

@freezed
sealed class NoticesEvent with _$NoticesEvent {
  const factory NoticesEvent.fetch(NoticeSearchQueryEntity query) = _Fetch;
  const factory NoticesEvent.fetchOne(NoticeSummaryEntity summary) = _FetchOne;
  const factory NoticesEvent.loadMore() = _LoadMore;
  const factory NoticesEvent.delete(NoticeSummaryEntity summary) = _Delete;
}

@freezed
sealed class NoticesState with _$NoticesState {
  const NoticesState._();
  const factory NoticesState.initial() = _Initial;
  const factory NoticesState.loading([
    @Default([]) List<NoticeSummaryEntity> notices,
  ]) = _Loading;
  const factory NoticesState.loaded(
    List<NoticeSummaryEntity> notices,
    int total,
    NoticeSearchQueryEntity lastQuery,
  ) = _Loaded;
  const factory NoticesState.single(
      NoticeSummaryEntity summary, NoticeEntity notice) = _Single;

  bool get loaded => mapOrNull(loaded: (_) => true) ?? false;
  List<NoticeSummaryEntity> get notices =>
      mapOrNull(loading: (m) => m.notices, loaded: (m) => m.notices) ?? [];
  NoticeSummaryEntity? get partial =>
      mapOrNull(loading: (m) => m.notices.single, single: (m) => m.summary);
  NoticeEntity? get single => mapOrNull(single: (m) => m.notice);
  int get total => mapOrNull(loaded: (m) => m.total) ?? 0;
}
