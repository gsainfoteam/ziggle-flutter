import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';

import '../../data/models/notice_model.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

Stream<T> _thottle<T>(Stream<T> events, Stream<T> Function(T) mapper) => events
    .throttleTime(const Duration(milliseconds: 500), trailing: true)
    .distinct()
    .switchMap(mapper);

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;
  final AnalyticsRepository _analyticsRepository;
  String? _query;

  NoticeListBloc(this._repository, this._analyticsRepository)
      : super(const _Initial()) {
    on<_Droppable>((event, emit) async {
      if (event is _Load) {
        emit(_Loading(type: event.type));
        final data = await _repository.getNotices(
          type: event.type,
          search: event.query,
        );
        _query = event.query;
        emit(_Loaded(total: data.total, list: data.list, type: event.type));
      } else if (event is _Reset) {
        _query = null;
        emit(_Initial(type: state.type));
      }
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
    on<_AddReaction>((event, emit) async {
      if (state is! _Loaded) return;
      emit(_Loading(total: state.total, list: state.list, type: state.type));
      final data = await _repository.addReaction(event.id, event.emoji);
      final list = state.list.replaceWithPersistContent(data);
      emit(_Loaded(total: state.total, list: list, type: state.type));
    });
    on<_RemoveReaction>((event, emit) async {
      if (state is! _Loaded) return;
      emit(_Loading(total: state.total, list: state.list, type: state.type));
      final data = await _repository.removeReaction(event.id, event.emoji);
      final list = state.list.replaceWithPersistContent(data);
      emit(_Loaded(total: state.total, list: list, type: state.type));
    });
    on<_AddReminder>((event, emit) async {
      if (state is! _Loaded) return;
      emit(_Loading(total: state.total, list: state.list, type: state.type));
      _analyticsRepository.logTryReminder();
      final data = await _repository.addReminder(event.id);
      final list = state.list.replaceWithPersistContent(data);
      emit(_Loaded(total: state.total, list: list, type: state.type));
      _analyticsRepository.logToggleReminder(data.isReminded);
    });
    on<_RemoveReminder>((event, emit) async {
      if (state is! _Loaded) return;
      emit(_Loading(total: state.total, list: state.list, type: state.type));
      _analyticsRepository.logTryReminder();
      final data = await _repository.removeReminder(event.id);
      final list = state.list.replaceWithPersistContent(data);
      emit(_Loaded(total: state.total, list: list, type: state.type));
      _analyticsRepository.logToggleReminder(data.isReminded);
    });
  }

  @override
  void onTransition(Transition<NoticeListEvent, NoticeListState> transition) {
    super.onTransition(transition);
    switch (transition.event) {
      case _Load e:
        switch (transition.nextState) {
          case _Loading _:
            _analyticsRepository.logSearch(e.query ?? '', e.type);
            break;
        }
        break;
    }
  }
}

@freezed
class NoticeListEvent with _$NoticeListEvent {
  @Implements<_Droppable>()
  const factory NoticeListEvent.load({
    @Default(NoticeType.all) NoticeType type,
    String? query,
  }) = _Load;
  const factory NoticeListEvent.loadMore() = _LoadMore;
  const factory NoticeListEvent.refresh() = _Refresh;
  @Implements<_Droppable>()
  const factory NoticeListEvent.reset() = _Reset;

  const factory NoticeListEvent.addReaction(int id, String emoji) =
      _AddReaction;
  const factory NoticeListEvent.removeReaction(int id, String emoji) =
      _RemoveReaction;
  const factory NoticeListEvent.addReminder(int id) = _AddReminder;
  const factory NoticeListEvent.removeReminder(int id) = _RemoveReminder;
}

mixin _Droppable on NoticeListEvent {}

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

extension on List<NoticeEntity> {
  List<NoticeEntity> replaceWithPersistContent(NoticeEntity notice) {
    final index = indexWhere((e) => e.id == notice.id);
    if (index == -1) return this;
    final list = toList();
    list[index] = NoticeModel.fromEntity(notice).copyWith(
      title: list[index].title,
      content: list[index].content,
    );
    return list;
  }
}
