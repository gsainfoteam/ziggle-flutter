import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notices_repository.dart';

part 'write_bloc.freezed.dart';

@injectable
class WriteBloc extends Bloc<WriteEvent, WriteState> {
  final AnalyticsRepository _analyticsRepository;
  final NoticesRepository _noticesRepository;

  WriteBloc(this._analyticsRepository, this._noticesRepository)
      : super(const WriteState.initial()) {
    on<_Init>(_init);
    on<_Save>(_save);
    on<_Write>(_write);
    on<_Translate>(_translate);
    on<_Additional>(_additional);
  }

  FutureOr<void> _init(_Init event, Emitter<WriteState> emit) async {
    final draft = await _noticesRepository.loadDraft();
    emit(WriteState.saved(draft ?? const NoticeWriteEntity()));
  }

  FutureOr<void> _save(_Save event, Emitter<WriteState> emit) {
    _noticesRepository.saveDraft(event.notice);
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
      final result = await _noticesRepository.writeNotice(notice);
      emit(WriteState.success(result));
    } catch (e) {
      _analyticsRepository.logSubmitArticleCancel('unknown error');
      emit(WriteState.error(e.toString()));
    }
  }

  FutureOr<void> _translate(_Translate event, Emitter<WriteState> emit) async {
    if (event.content.isEmpty) return emit(const WriteState.bodyMissing());
    emit(const WriteState.writing());
    try {
      final result = await _noticesRepository.translateNotice(
        event.notice,
        event.content,
      );
      emit(WriteState.success(result));
    } catch (e) {
      emit(WriteState.error(e.toString()));
    }
  }

  FutureOr<void> _additional(
      _Additional event, Emitter<WriteState> emit) async {
    if (event.content.isEmpty) return emit(const WriteState.bodyMissing());
    emit(const WriteState.writing());
    try {
      final result = await _noticesRepository.additionalNotice(
        event.notice,
        event.content,
        event.deadline,
      );
      emit(WriteState.success(result));
    } catch (e) {
      emit(WriteState.error(e.toString()));
    }
  }
}

@freezed
sealed class WriteEvent with _$WriteEvent {
  const factory WriteEvent.init() = _Init;
  const factory WriteEvent.save(NoticeWriteEntity notice) = _Save;
  const factory WriteEvent.write(NoticeWriteEntity notice) = _Write;
  const factory WriteEvent.translate(NoticeEntity notice, String content) =
      _Translate;
  const factory WriteEvent.additional(
      NoticeEntity notice, String content, DateTime? deadline) = _Additional;
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
  bool get error => whenOrNull(error: (_) => true) ?? false;
  bool get success => whenOrNull(success: (_) => true) ?? false;
  NoticeSummaryEntity? get resultSummary => NoticeSummaryEntity(
        id: whenOrNull(success: (result) => result.id) ?? 0,
        createdAt: DateTime.now(),
      );
}
