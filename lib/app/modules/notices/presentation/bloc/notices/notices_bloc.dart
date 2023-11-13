import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/notice_search_query_entity.dart';
import '../../../domain/entities/notice_summary_entity.dart';

part 'notices_bloc.freezed.dart';

@injectable
class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  NoticesBloc() : super(const NoticesState.initial()) {
    on<_Fetch>((event, emit) {});
    on<_LoadMore>((event, emit) {});
  }
}

@freezed
class NoticesEvent with _$NoticesEvent {
  const factory NoticesEvent.fetch(NoticeSearchQueryEntity query) = _Fetch;
  const factory NoticesEvent.loadMore() = _LoadMore;
}

@freezed
class NoticesState with _$NoticesState {
  const factory NoticesState.initial() = _Initial;
  const factory NoticesState.loaded(
    List<NoticeSummaryEntity> notices,
    bool more,
    NoticeSearchQueryEntity lastQuery,
  ) = _Loaded;
}
