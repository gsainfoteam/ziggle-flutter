import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

Stream<T> _thottle<T>(Stream<T> events, Stream<T> Function(T) mapper) => events
    .throttleTime(const Duration(milliseconds: 500), trailing: true)
    .switchMap(mapper);

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;
  String? _query;

  NoticeListBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      if (event.query != null && _query == event.query) return;
      emit(_Loading(type: event.type));
      final data = await _repository.getNotices(
        type: event.type,
        search: event.query,
      );
      _query = event.query;
      emit(_Loaded(total: data.total, list: data.list, type: event.type));
    }, transformer: _thottle);
    on<_LoadMore>((event, emit) async {
      if (state is! _Loaded) return;
      if (state.list.length >= state.total) return;
      emit(_Loading(total: state.total, list: state.list, type: state.type));
      final data = await _repository.getNotices(
          offset: state.list.length, type: state.type, search: _query);
      emit(_Loaded(
        total: data.total,
        list: [...state.list, ...data.list],
        type: state.type,
      ));
    });
    on<_Refresh>((event, emit) async {
      emit(_Loading(type: state.type));
      final data = await _repository.getNotices(
        type: state.type,
        search: _query,
      );
      emit(_Loaded(total: data.total, list: data.list, type: state.type));
    });
    on<_Reset>((event, emit) {
      _query = null;
      emit(const _Initial());
    });
  }
}

@freezed
class NoticeListEvent with _$NoticeListEvent {
  const factory NoticeListEvent.load({
    @Default(NoticeType.all) NoticeType type,
    String? query,
  }) = _Load;
  const factory NoticeListEvent.loadMore() = _LoadMore;
  const factory NoticeListEvent.refresh() = _Refresh;
  const factory NoticeListEvent.reset() = _Reset;
}

@freezed
class NoticeListState with _$NoticeListState {
  const NoticeListState._();
  const factory NoticeListState.initial({
    @Default(0) int total,
    @Default([]) List<NoticeEntity> list,
    @Default(NoticeType.all) NoticeType type,
  }) = _Initial;
  const factory NoticeListState.loading({
    @Default(0) int total,
    @Default([]) List<NoticeEntity> list,
    required NoticeType type,
  }) = _Loading;
  const factory NoticeListState.loaded({
    required int total,
    required List<NoticeEntity> list,
    required NoticeType type,
  }) = _Loaded;

  bool get loaded => this is _Loaded;
}
