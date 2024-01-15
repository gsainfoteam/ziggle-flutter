import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';

part 'notice_list_bloc.freezed.dart';

@injectable
class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final NoticeRepository _repository;

  NoticeListBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) {
      emit(const _Loading());
      _repository.getNotices();
    });
  }
}

@freezed
class NoticeListEvent with _$NoticeListEvent {
  const factory NoticeListEvent.load() = _Load;
}

@freezed
class NoticeListState with _$NoticeListState {
  const factory NoticeListState.initial() = _Initial;
  const factory NoticeListState.loading() = _Loading;
  const factory NoticeListState.loaded() = _Loaded;
}
