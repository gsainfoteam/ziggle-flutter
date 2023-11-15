import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';

part 'report_bloc.freezed.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final AnalyticsRepository _analyticsRepository;

  ReportBloc(this._analyticsRepository) : super(const ReportState.initial()) {
    on<_Report>(_report);
  }

  FutureOr<void> _report(event, emit) {
    if (event.confirm) {
      _analyticsRepository.logReport();
      emit(const ReportState.done());
    } else {
      _analyticsRepository.logTryReport();
      emit(const ReportState.confirm());
    }
    emit(const ReportState.initial());
  }
}

@freezed
sealed class ReportEvent with _$ReportEvent {
  const factory ReportEvent.report(NoticeSummaryEntity notice,
      [@Default(false) bool confirm]) = _Report;
}

@freezed
sealed class ReportState with _$ReportState {
  const ReportState._();
  const factory ReportState.initial() = _Initial;
  const factory ReportState.confirm() = _Confirm;
  const factory ReportState.done() = _Done;
}
