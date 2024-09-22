import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/common/presentation/utils/reactive.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_reaction.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;

  late NoticeType _type;
  String? query;
  late int total;

  NoticeListBloc(this._repository) : super(const _Initial()) {
    on<_SearchEvent>((event, emit) async {
      if (event is _Load) {
        emit(const _Loading());
        _type = event.type;
        query = event.query;
        final notices =
            await _repository.getNotices(type: _type, search: query);
        total = notices.total;
        emit(_Loaded(notices.list));
      } else if (event is _Reset) {
        query = null;
        emit(const _Initial());
      }
    }, transformer: makeEventThrottler());
    on<_Refresh>((event, emit) async {
      emit(const _Loading());
      final notices = await _repository.getNotices(type: _type, search: query);
      total = notices.total;
      emit(_Loaded(notices.list));
    });
    on<_LoadMore>((event, emit) async {
      if (state is! _Loaded) return;
      if (state.notices.length >= total) return;
      emit(_Loading(state.notices));
      final notices = await _repository.getNotices(
        type: _type,
        offset: state.notices.length,
        search: query,
      );
      total = notices.total;
      emit(_Loaded([...state.notices, ...notices.list]));
    });
    on<_AddLike>((event, emit) async {
      if (state is! _Loaded) return;
      final notice = event.notice;
      final index = state.notices.indexWhere((n) => n.id == notice.id);
      if (index == -1) return;
      final notices = List<NoticeEntity>.from(state.notices);
      notices[index] = notice.addReaction(NoticeReaction.like);
      emit(_Loaded(notices));
      final result =
          await _repository.addReaction(notice.id, NoticeReaction.like.emoji);
      notices[index] = notices[index].copyWith(reactions: result.reactions);
      emit(_Loaded(notices));
    });
    on<_RemoveLike>((event, emit) async {
      if (state is! _Loaded) return;
      final notice = event.notice;
      final index = state.notices.indexWhere((n) => n.id == notice.id);
      if (index == -1) return;
      final notices = List<NoticeEntity>.from(state.notices);
      notices[index] = notice.removeReaction(NoticeReaction.like);
      emit(_Loaded(notices));
      final result = await _repository.removeReaction(
          notice.id, NoticeReaction.like.emoji);
      notices[index] = notices[index].copyWith(reactions: result.reactions);
      emit(_Loaded(notices));
    });
  }

  static Future<void> refresh(BuildContext context) async {
    final bloc = context.read<NoticeListBloc>();
    final blocker = bloc.stream.firstWhere((state) => !state.isLoading);
    bloc.add(const NoticeListEvent.refresh());
    await blocker;
  }

  static Future<void> loadMore(BuildContext context) async {
    final bloc = context.read<NoticeListBloc>();
    final blocker = bloc.stream.firstWhere((state) => !state.isLoading);
    bloc.add(const NoticeListEvent.loadMore());
    await blocker;
  }
}

mixin _SearchEvent implements NoticeListEvent {}

@freezed
sealed class NoticeListEvent {
  @With<_SearchEvent>()
  const factory NoticeListEvent.load(
    NoticeType type, {
    String? query,
  }) = _Load;
  const factory NoticeListEvent.refresh() = _Refresh;
  const factory NoticeListEvent.loadMore() = _LoadMore;
  @With<_SearchEvent>()
  const factory NoticeListEvent.reset() = _Reset;

  const factory NoticeListEvent.addLike(NoticeEntity notice) = _AddLike;
  const factory NoticeListEvent.removeLike(NoticeEntity notice) = _RemoveLike;
}

@freezed
sealed class NoticeListState with _$NoticeListState {
  const NoticeListState._();

  const factory NoticeListState.initial(
      [@Default([]) List<NoticeEntity> notices]) = _Initial;
  const factory NoticeListState.loading(
      [@Default([]) List<NoticeEntity> notices]) = _Loading;
  const factory NoticeListState.loaded(List<NoticeEntity> notices) = _Loaded;
  const factory NoticeListState.error(String error,
      [@Default([]) List<NoticeEntity> notices]) = _Error;

  bool get isLoading => this is _Loading;
  bool get showLoading => isLoading && notices.isEmpty;
}
