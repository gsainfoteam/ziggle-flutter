import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;

  NoticeListBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(const _Loading());
      final data = await _repository.getNotices();
      emit(_Loaded(total: data.total, list: data.list));
    });
  }
}

@freezed
class NoticeListEvent with _$NoticeListEvent {
  const factory NoticeListEvent.load() = _Load;
}

@freezed
class NoticeListState with _$NoticeListState {
  const NoticeListState._();
  const factory NoticeListState.initial({
    @Default(0) int total,
    @Default([]) List<NoticeEntity> list,
  }) = _Initial;
  const factory NoticeListState.loading({
    @Default(0) int total,
    @Default([]) List<NoticeEntity> list,
  }) = _Loading;
  const factory NoticeListState.loaded({
    required int total,
    required List<NoticeEntity> list,
  }) = _Loaded;

  bool get loaded => this is _Loaded;
}
