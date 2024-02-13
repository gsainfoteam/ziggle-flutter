import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';

part 'write_bloc.freezed.dart';

@injectable
class WriteBloc extends Bloc<WriteEvent, WriteState> {
  final NoticeRepository _repository;
  final AnalyticsRepository _analyticsRepository;

  WriteBloc(this._repository, this._analyticsRepository)
      : super(const _Initial()) {
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
    on<_AddForeign>((event, emit) async {
      emit(const WriteState.loading());
      try {
        final notice = await _repository.writeForeign(
          id: event.notice.id,
          title: event.title,
          content: event.content,
          contentId: event.contentId,
          lang: event.lang,
          deadline: event.notice.additionalContents
                  .firstWhereOrNull((element) => element.id == event.contentId)
                  ?.deadline ??
              event.notice.deadline,
        );
        emit(WriteState.loaded(notice));
      } catch (e) {
        emit(WriteState.error(e.toString()));
        emit(const WriteState.initial());
      }
    });
    on<_WriteAdditional>((event, emit) async {
      emit(const WriteState.loading());
      try {
        final notice = await _repository.addAdditionalContent(
          id: event.notice.id,
          content: event.content,
          deadline: event.deadline,
          notifyToAll: event.notifyToAll,
        );
        emit(WriteState.loaded(notice));
      } catch (e) {
        emit(WriteState.error(e.toString()));
        emit(const WriteState.initial());
      }
    });
  }

  @override
  void onChange(Change<WriteState> change) {
    super.onChange(change);
    switch (change.nextState) {
      case _Initial _:
        break;
      case _Loading _:
        _analyticsRepository.logTrySubmitArticle();
        break;
      case _Loaded _:
        _analyticsRepository.logSubmitArticle();
        break;
      case _Error e:
        _analyticsRepository.logSubmitArticleCancel(e.message);
        break;
    }
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
  const factory WriteEvent.writeForeign({
    required NoticeEntity notice,
    String? title,
    required String content,
    @Default(1) int contentId,
    @Default(AppLocale.en) AppLocale lang,
  }) = _AddForeign;
  const factory WriteEvent.writeAdditional({
    required NoticeEntity notice,
    required String content,
    DateTime? deadline,
    bool? notifyToAll,
  }) = _WriteAdditional;
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
