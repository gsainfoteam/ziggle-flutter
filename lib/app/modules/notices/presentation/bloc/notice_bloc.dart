import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';

part 'notice_bloc.freezed.dart';

@injectable
class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository _repository;

  NoticeBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      emit(_Loaded(event.entity));
      final entity = await _repository.getNotice(event.entity.id);
      emit(_Loaded(entity));
    });
  }
}

@freezed
sealed class NoticeEvent with _$NoticeEvent {
  const factory NoticeEvent.load(NoticeEntity entity) = _Load;
}

@freezed
sealed class NoticeState with _$NoticeState {
  const NoticeState._();
  const factory NoticeState.initial() = _Initial;
  const factory NoticeState.loaded(NoticeEntity entity) = _Loaded;

  NoticeEntity? get entity => mapOrNull(loaded: (state) => state.entity);
}
