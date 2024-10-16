import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_create_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_create_bloc.freezed.dart';

@injectable
class GroupCreateBloc extends Bloc<GroupCreateEvent, GroupCreateState> {
  final GroupRepository _repository;

  GroupCreateBloc(this._repository) : super(const _Draft()) {
    on<_SetName>(
        (event, emit) => emit(_Draft(state.draft.copyWith(name: event.name))));
    on<_SetDescription>((event, emit) => emit(_Draft(state.draft.copyWith(
          description: event.description,
        ))));
    on<_SetNotionPageId>((event, emit) =>
        emit(_Draft(state.draft.copyWith(notionPageId: event.notionPageId))));
    on<_Create>((event, emit) async {
      print(
          'name : ${state.draft.name}, description : ${state.draft.description}');
      _repository.createGroup(
        name: state.draft.name,
        description: state.draft.description,
        notionPageId: state.draft.notionPageId,
      );
      print('creation done');
    });
  }
}

@freezed
class GroupCreateEvent with _$GroupCreateEvent {
  const factory GroupCreateEvent.setName(String name) = _SetName;
  const factory GroupCreateEvent.setImages(File images) = _SetImages;
  const factory GroupCreateEvent.setDescription(String description) =
      _SetDescription;
  const factory GroupCreateEvent.setNotionPageId(String notionPageId) =
      _SetNotionPageId;
  const factory GroupCreateEvent.create() = _Create;
}

@freezed
class GroupCreateState with _$GroupCreateState {
  const GroupCreateState._();

  const factory GroupCreateState.draft(
      [@Default(GroupCreateEntity()) GroupCreateEntity draft]) = _Draft;
}
