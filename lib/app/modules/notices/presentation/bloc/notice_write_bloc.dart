import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'notice_write_bloc.freezed.dart';

@injectable
class NoticeWriteBloc extends Bloc<NoticeWriteEvent, NoticeWriteState> {
  NoticeWriteBloc() : super(const _Draft()) {
    on<_SetTitle>(
      (event, emit) => emit(_Draft(state.draft.copyWith(
        titles: {...state.draft.titles, event.lang: event.title},
      ))),
    );
    on<_SetBody>(
      (event, emit) => emit(_Draft(state.draft.copyWith(
        bodies: {...state.draft.bodies, event.lang: event.body},
      ))),
    );
    on<_SetImages>((event, emit) =>
        emit(_Draft(state.draft.copyWith(images: event.images))));
    on<_SetConfig>((event, emit) => emit(_Draft(state.draft.copyWith(
          type: event.type,
          tags: event.tags,
          deadline: event.deadline,
        ))));
  }
}

@freezed
class NoticeWriteEvent {
  const factory NoticeWriteEvent.setTitle(String title,
      [@Default(AppLocale.ko) AppLocale lang]) = _SetTitle;
  const factory NoticeWriteEvent.setBody(String body,
      [@Default(AppLocale.ko) AppLocale lang]) = _SetBody;
  const factory NoticeWriteEvent.setImages(List<File> images) = _SetImages;
  const factory NoticeWriteEvent.setConfig({
    required NoticeType type,
    required List<String> tags,
    DateTime? deadline,
  }) = _SetConfig;
}

@freezed
class NoticeWriteState with _$NoticeWriteState {
  const factory NoticeWriteState.draft(
          [@Default(NoticeWriteDraftEntity()) NoticeWriteDraftEntity draft]) =
      _Draft;
}
