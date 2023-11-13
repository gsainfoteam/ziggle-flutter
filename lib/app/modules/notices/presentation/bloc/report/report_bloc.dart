import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';

part 'report_bloc.freezed.dart';

@injectable
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(const ReportState.initial()) {
    on<_Report>((event, emit) {
      emit(const ReportState.done());
    });
  }
}

@freezed
sealed class ReportEvent with _$ReportEvent {
  const factory ReportEvent.report(NoticeSummaryEntity notice) = _Report;
}

@freezed
sealed class ReportState with _$ReportState {
  const ReportState._();
  const factory ReportState.initial() = _Initial;
  const factory ReportState.done() = _Done;
}
