import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
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
  late NoticeSummaryEntity _summary;
  NoticeEntity? _notice;
  bool get _tooltip => _reminderRepository.shouldShowReminderTooltip;

  ReminderBloc(
    this._repository,
    this._userRepository,
    this._reminderRepository,
  ) : super(const ReminderState.initial()) {
    on<_Fetch>((event, emit) async {
      _summary = event.notice;
      emit(ReminderState.loading(false, _tooltip));
      _notice = await _repository.getNotice(_summary);
      emit(ReminderState.value(_notice!.reminder, _tooltip));
    });
    on<_Toggle>((event, emit) async {
      if (_notice == null) return;
      try {
        await _userRepository.userInfo();
        emit(ReminderState.loading(!_notice!.reminder, false));
        if (_notice!.reminder) {
          await _repository.cancelReminder(_notice!);
        } else {
          await _repository.setReminder(_notice!);
        }
        _notice = await _repository.getNotice(_summary);
        await _reminderRepository.hideReminderTooltip();
        emit(ReminderState.value(_notice!.reminder, false));
      } catch (_) {
        emit(ReminderState.value(_notice!.reminder, _tooltip));
      }
    });
    on<_Dismiss>((event, emit) async {
      await _reminderRepository.hideReminderTooltip();
      emit(ReminderState.value(_notice!.reminder, false));
    });
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
}
