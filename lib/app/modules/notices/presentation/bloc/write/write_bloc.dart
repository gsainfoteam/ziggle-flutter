import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';

part 'write_bloc.freezed.dart';

@injectable
class WriteBloc extends Bloc<WriteEvent, WriteState> {
  final AnalyticsRepository _analyticsRepository;

  WriteBloc(this._analyticsRepository) : super(const WriteState.initial()) {
    on<_Init>(_init);
    on<_Write>(_write);
  }

  FutureOr<void> _init(_Init event, Emitter<WriteState> emit) {
    emit(const WriteState.saved(NoticeWriteEntity()));
  }

  FutureOr<void> _write(_Write event, Emitter<WriteState> emit) async {
    _analyticsRepository.logTrySubmitArticle();
    final notice = event.notice;
    if (notice.title.isEmpty) return emit(const WriteState.titleMissing());
    if (notice.type == null) return emit(const WriteState.typeMissing());
    if (notice.body.isEmpty) return emit(const WriteState.bodyMissing());
    emit(const WriteState.writing());
    try {
      _analyticsRepository.logSubmitArticle();
      emit(WriteState.success(NoticeEntity(
        id: 66,
        createdAt: DateTime.now(),
      )));
    } catch (e) {
      emit(WriteState.error(e.toString()));
    }
  }
}

@freezed
sealed class WriteEvent with _$WriteEvent {
  const factory WriteEvent.init() = _Init;
  const factory WriteEvent.write(NoticeWriteEntity notice) = _Write;
}

@freezed
sealed class WriteState with _$WriteState {
  const WriteState._();
  const factory WriteState.initial() = _Initial;
  const factory WriteState.saved(NoticeWriteEntity notice) = _Saved;
  const factory WriteState.titleMissing() = _TitleMissing;
  const factory WriteState.typeMissing() = _TypeMissing;
  const factory WriteState.bodyMissing() = _BodyMissing;
  const factory WriteState.writing() = _Writing;
  const factory WriteState.error(String reason) = _Error;
  const factory WriteState.success(NoticeEntity result) = _Success;

  NoticeWriteEntity get notice =>
      whenOrNull(saved: (notice) => notice) ?? const NoticeWriteEntity();
  bool get missing =>
      whenOrNull(
        titleMissing: () => true,
        typeMissing: () => true,
        bodyMissing: () => true,
      ) ??
      false;
}
