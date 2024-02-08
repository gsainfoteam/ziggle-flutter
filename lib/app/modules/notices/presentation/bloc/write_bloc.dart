import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';

part 'write_bloc.freezed.dart';

@injectable
class WriteBloc extends Bloc<WriteEvent, WriteState> {
  final NoticeRepository _repository;

  WriteBloc(this._repository) : super(const _Initial()) {
    on<_Write>((event, emit) async {
      emit(const WriteState.loading());
      try {
        final notice = await _repository.write(
          title: event.title,
          content: event.content,
          type: event.type,
          deadline: event.deadline,
          tags: event.tags,
          images: event.images,
          documents: event.documents,
        );
        emit(WriteState.loaded(notice));
      } catch (e) {
        emit(WriteState.error(e.toString()));
        emit(const WriteState.initial());
      }
    });
  }
}

@freezed
class WriteEvent with _$WriteEvent {
  const factory WriteEvent.write({
    required String title,
    required String content,
    required NoticeType type,
    DateTime? deadline,
    @Default([]) List<String> tags,
    @Default([]) List<File> images,
    @Default([]) List<File> documents,
  }) = _Write;
}

@freezed
class WriteState with _$WriteState {
  const WriteState._();

  const factory WriteState.initial() = _Initial;
  const factory WriteState.loading() = _Loading;
  const factory WriteState.loaded(NoticeEntity notice) = _Loaded;
  const factory WriteState.error(String message) = _Error;

  bool get isLoading => this is _Loading;
  bool get isLoaded => this is _Loaded;
  NoticeEntity get notice => (this as _Loaded).notice;
}
