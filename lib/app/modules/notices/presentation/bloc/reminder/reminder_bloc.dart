import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';

part 'reminder_bloc.freezed.dart';

@injectable
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(const ReminderState.initial()) {
    on<_Fetch>((event, emit) {});
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
  const factory ReminderState.initial() = _Initial;
  const factory ReminderState.value(bool value, bool showTooltip) = _Value;

  bool get value => mapOrNull(value: (m) => m.value) ?? false;
  bool get showTooltip => mapOrNull(value: (m) => m.showTooltip) ?? false;
}
