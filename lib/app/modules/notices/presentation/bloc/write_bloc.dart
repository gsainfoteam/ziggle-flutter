import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';

part 'write_bloc.freezed.dart';

class WriteBloc extends Bloc<WriteEvent, WriteState> {
  final NoticeRepository _repository;

  WriteBloc(this._repository) : super(const _Initial()) {
    on<_Write>((event, emit) async {
      emit(const WriteState.loading());
      final notice = await _repository.write(
        title: event.title,
        content: event.content,
        type: event.type,
        tags: event.tags,
        images: event.images,
        documents: event.documents,
      );
      emit(WriteState.loaded(notice));
    });
  }
}

@freezed
class WriteEvent with _$WriteEvent {
  const factory WriteEvent.write({
    required String title,
    required String content,
    required NoticeType type,
    @Default([]) List<String> tags,
    @Default([]) List<File> images,
    @Default([]) List<File> documents,
  }) = _Write;
}

@freezed
class WriteState with _$WriteState {
  const factory WriteState.initial() = _Initial;
  const factory WriteState.loading() = _Loading;
  const factory WriteState.loaded(NoticeEntity notice) = _Loaded;
}
