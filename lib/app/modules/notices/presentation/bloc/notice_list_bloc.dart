import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;

  NoticeListBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(_Loading(type: event.type));
      final data = await _repository.getNotices(type: event.type);
      emit(_Loaded(total: data.total, list: data.list, type: event.type));
    });
    on<_Refresh>((event, emit) async {
      emit(_Loading(type: state.type));
      final data = await _repository.getNotices(type: state.type);
      emit(_Loaded(total: data.total, list: data.list, type: state.type));
    });
  }
}

@freezed
class NoticeListEvent with _$NoticeListEvent {
  const factory NoticeListEvent.load([
    @Default(NoticeType.all) NoticeType type,
  ]) = _Load;
  const factory NoticeListEvent.refresh() = _Refresh;
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
