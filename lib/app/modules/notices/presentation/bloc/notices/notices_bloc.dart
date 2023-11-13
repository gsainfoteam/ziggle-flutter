import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
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
        notices.total > event.query.offset + event.query.limit,
        event.query,
      ));
    });
    on<_LoadMore>((event, emit) async {
      final query = state.mapOrNull(loaded: (m) => m.lastQuery);
      if (query == null) return;
      final oldList = state.mapOrNull(loaded: (m) => m.notices) ?? [];
      emit(NoticesState.loading(oldList));
      final newQuery = query.copyWith(offset: query.offset + query.limit);
      final notices = await _repository.getNotices(newQuery);
      emit(NoticesState.loaded(
        [...oldList, ...notices.list],
        notices.total > newQuery.offset + newQuery.limit,
        newQuery,
      ));
    });
  }
}

@freezed
class NoticesEvent with _$NoticesEvent {
  const factory NoticesEvent.fetch(NoticeSearchQueryEntity query) = _Fetch;
  const factory NoticesEvent.loadMore() = _LoadMore;
}

@freezed
class NoticesState with _$NoticesState {
  NoticesState._();
  const factory NoticesState.initial() = _Initial;
  const factory NoticesState.loading([
    @Default([]) List<NoticeSummaryEntity>? notices,
  ]) = _Loading;
  const factory NoticesState.loaded(
    List<NoticeSummaryEntity> notices,
    bool more,
    NoticeSearchQueryEntity lastQuery,
  ) = _Loaded;

  bool get loaded => mapOrNull(loaded: (_) => true) ?? false;
}
