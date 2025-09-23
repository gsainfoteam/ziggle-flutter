import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/common/presentation/utils/reactive.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_create_draft_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'group_create_bloc.freezed.dart';

@injectable
class GroupCreateBloc extends Bloc<GroupCreateEvent, GroupCreateState> {
  final GroupRepository _repository;

  GroupCreateBloc(this._repository) : super(const _Draft()) {
    on<_SetName>((event, emit) async {
      if (event.name.isNotEmpty) {
        final isExisted = await _repository.checkGroupExistence(event.name);
        if (isExisted) {
          emit(
            _Error(state.draft, t.group.creation.profile.name.sameNameError),
          );
          return;
        }
      }
      emit(
        _Draft(
          state.draft.copyWith(
            name: event.name,
            description: state.draft.description,
          ),
        ),
      );
    }, transformer: makeEventThrottler());
    on<_SetImage>(
      (event, emit) => emit(_Draft(state.draft.copyWith(image: event.image))),
    );
    on<_SetDescription>(
      (event, emit) =>
          emit(_Draft(state.draft.copyWith(description: event.description))),
    );
    on<_SetNotionPageId>(
      (event, emit) =>
          emit(_Draft(state.draft.copyWith(notionPageId: event.notionPageId))),
    );
    on<_Create>((event, emit) async {
      emit(_Loading(state.draft.copyWith()));
      try {
        final group = await _repository.createGroup(
          name: state.draft.name,
          image: state.draft.image,
          description: state.draft.description,
          notionPageId: state.draft.notionPageId,
        );
        emit(_Done(state.draft.copyWith(), group));
      } on Exception catch (e) {
        emit(_Error(state.draft, e.toString()));
      }
    });
  }
}

@freezed
class GroupCreateEvent with _$GroupCreateEvent {
  const factory GroupCreateEvent.setName(String name) = _SetName;
  const factory GroupCreateEvent.setImage(File? image) = _SetImage;
  const factory GroupCreateEvent.setDescription(String description) =
      _SetDescription;
  const factory GroupCreateEvent.setNotionPageId(String notionPageId) =
      _SetNotionPageId;
  const factory GroupCreateEvent.create() = _Create;
}

@freezed
sealed class GroupCreateState with _$GroupCreateState {
  const GroupCreateState._();

  const factory GroupCreateState.draft([
    @Default(GroupCreateDraftEntity(notionPageId: ''))
    GroupCreateDraftEntity draft,
  ]) = _Draft;
  const factory GroupCreateState.loading(GroupCreateDraftEntity draft) =
      _Loading;
  const factory GroupCreateState.done(
    GroupCreateDraftEntity draft,
    GroupEntity group,
  ) = _Done;
  const factory GroupCreateState.error(
    GroupCreateDraftEntity draft,
    String error,
  ) = _Error;

  bool get isLoading => this is _Loading;
  bool get isNameEmpty => draft.name.isEmpty;
  bool get isImageEmpty => draft.image == null;
  bool get isDescriptionEmpty => draft.description.isEmpty;
  bool get isNotionPageIdEmpty => draft.notionPageId?.isEmpty ?? true;
}
