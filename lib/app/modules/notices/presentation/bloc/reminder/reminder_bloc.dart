import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/auth/domain/repositories/user_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notices_repository.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/reminder_repository.dart';

part 'reminder_bloc.freezed.dart';

@injectable
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final NoticesRepository _repository;
  final UserRepository _userRepository;
  final ReminderRepository _reminderRepository;
  final AnalyticsRepository _analyticsRepository;
  late NoticeSummaryEntity _summary;
  NoticeEntity? _notice;
  bool get _tooltip =>
      _reminderRepository.shouldShowReminderTooltip &&
      _notice != null &&
      _notice!.currentDeadline != null &&
      _notice!.currentDeadline!.isAfter(DateTime.now());

  ReminderBloc(
    this._repository,
    this._userRepository,
    this._reminderRepository,
    this._analyticsRepository,
  ) : super(const ReminderState.initial()) {
    on<_Fetch>(_fetch);
    on<_Toggle>(_toggle);
    on<_Dismiss>(_dismiss);
  }

  FutureOr<void> _dismiss(_Dismiss event, Emitter<ReminderState> emit) async {
    _analyticsRepository.logHideReminderTooltip();
    await _reminderRepository.hideReminderTooltip();
    emit(ReminderState.value(_notice!.reminder, false));
  }

  FutureOr<void> _toggle(_Toggle event, Emitter<ReminderState> emit) async {
    if (_notice == null) return;
    try {
      await _userRepository.userInfo().first;
      emit(ReminderState.loading(!_notice!.reminder, false));
      if (_notice!.reminder) {
        await _repository.cancelReminder(_notice!);
      } else {
        await _repository.setReminder(_notice!);
      }
      _notice = await _repository.getNotice(_summary);
      await _reminderRepository.hideReminderTooltip();
      _analyticsRepository.logToggleReminder(_notice!.reminder);
      emit(ReminderState.value(_notice!.reminder, false));
    } catch (_) {
      _analyticsRepository.logTryReminder();
      emit(ReminderState.loginRequired(_tooltip));
      emit(ReminderState.value(_notice!.reminder, _tooltip));
    }
  }

  FutureOr<void> _fetch(_Fetch event, Emitter<ReminderState> emit) async {
    _summary = event.notice;
    emit(ReminderState.loading(false, _tooltip));
    _notice = await _repository.getNotice(_summary);
    emit(ReminderState.value(_notice!.reminder, _tooltip));
  }
}

@freezed
sealed class ReminderEvent with _$ReminderEvent {
  const factory ReminderEvent.fetch(NoticeSummaryEntity notice) = _Fetch;
  const factory ReminderEvent.toggle() = _Toggle;
  const factory ReminderEvent.dismiss() = _Dismiss;
}

@freezed
sealed class ReminderState with _$ReminderState {
  const ReminderState._();
  const factory ReminderState.initial([
    @Default(false) bool value,
    @Default(false) bool showTooltip,
  ]) = _Initial;
  const factory ReminderState.loading(bool value, bool showTooltip) = _Loading;
  const factory ReminderState.value(bool value, bool showTooltip) = _Value;
  const factory ReminderState.loginRequired(bool showTooltip,
      [@Default(false) bool value]) = _LoginRequired;
}
