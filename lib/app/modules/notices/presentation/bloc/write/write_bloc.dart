import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/analytics_repository.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';

part 'write_bloc.freezed.dart';

@injectable
class WriteBloc extends Bloc<WriteEvent, WriteState> {
  final AnalyticsRepository _analyticsRepository;

  WriteBloc(this._analyticsRepository) : super(const WriteState.initial()) {
    on<_Init>(_init);
  }

  FutureOr<void> _init(_Init event, Emitter<WriteState> emit) {
    emit(const WriteState.saved(NoticeWriteEntity()));
  }
}

@freezed
sealed class WriteEvent with _$WriteEvent {
  const factory WriteEvent.init() = _Init;
  const factory WriteEvent.write(NoticeWriteEntity notice) = _Write;
}

@freezed
sealed class WriteState with _$WriteState {
  const factory WriteState.initial([
    @Default(NoticeWriteEntity()) NoticeWriteEntity notice,
  ]) = _Initial;
  const factory WriteState.saved(NoticeWriteEntity notice) = _Saved;
  const factory WriteState.missingField([
    @Default(NoticeWriteEntity()) NoticeWriteEntity notice,
  ]) = _MissingField;
}
