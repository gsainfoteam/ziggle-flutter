import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;

  late NoticeType type;
  late int total;

  NoticeListBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(const _Loading());
      type = event.type;
      final notices = await _repository.getNotices(type: type);
      total = notices.total;
      emit(_Loaded(notices.list));
    });
    on<_Refresh>((event, emit) async {
      emit(const _Loading());
      final notices = await _repository.getNotices(type: type);
      total = notices.total;
      emit(_Loaded(notices.list));
    });
    on<_LoadMore>((event, emit) async {
      if (state is! _Loaded) return;
      if (state.notices.length >= total) return;
      emit(const _Loading());
      final notices = await _repository.getNotices(
        type: type,
        offset: state.notices.length,
      );
      total = notices.total;
      emit(_Loaded([...state.notices, ...notices.list]));
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

@freezed
sealed class NoticeListEvent {
  const factory NoticeListEvent.load(NoticeType type) = _Load;
  const factory NoticeListEvent.refresh() = _Refresh;
  const factory NoticeListEvent.loadMore() = _LoadMore;
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
