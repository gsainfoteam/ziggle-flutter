import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notices_repository.dart';

import '../../../domain/entities/notice_search_query_entity.dart';
import '../../../domain/entities/notice_summary_entity.dart';

part 'notices_bloc.freezed.dart';

@injectable
class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  final NoticesRepository _repository;

  NoticesBloc(this._repository) : super(const NoticesState.initial()) {
    on<_Fetch>((event, emit) async {
      emit(const NoticesState.loading());
      final notices = await _repository.getNotices(event.query);
      emit(NoticesState.loaded(
        notices.list,
        notices.total,
        event.query,
      ));
    });
    on<_LoadMore>((event, emit) async {
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
    });
    on<_FetchOne>((event, emit) async {
      emit(NoticesState.loading([event.summary]));
      final notice = await _repository.getNotice(event.summary);
      emit(NoticesState.single(event.summary, notice));
    },
        transformer: (events, mapper) =>
            events.throttleTime(const Duration(milliseconds: 500)));
  }
}

@freezed
sealed class NoticesEvent with _$NoticesEvent {
  const factory NoticesEvent.fetch(NoticeSearchQueryEntity query) = _Fetch;
  const factory NoticesEvent.fetchOne(NoticeSummaryEntity summary) = _FetchOne;
  const factory NoticesEvent.loadMore() = _LoadMore;
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
