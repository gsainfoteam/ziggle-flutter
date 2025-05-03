import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_rest_auth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'group_management_bloc.freezed.dart';

@injectable
class GroupManagementBloc
    extends Bloc<GroupManagementEvent, GroupManagementState> {
  final GroupRepository _repository;
  final RestAuthRepository _authRepository;
  late GroupEntity _group;

  GroupManagementBloc(this._repository,
      @Named.from(GroupsRestAuthRepository) this._authRepository)
      : super(GroupManagementState.initial()) {
    on<_Load>((event, emit) async {
      emit(GroupManagementState.loading());
      _group = event.group;
      final fetchedGroup = await _repository.getGroup(_group.uuid);
      emit(GroupManagementState.success(fetchedGroup));
    });
    on<_UpdateProfileImage>((event, emit) async {
      emit(GroupManagementState.loading());
      await _repository.modifyProfileImage(
          uuid: event.uuid, image: event.image);
      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });
    on<_UpdateName>((event, emit) async {
      emit(GroupManagementState.loading());
      try {
        await _repository.modifyGroup(
            uuid: event.uuid,
            name: event.name,
            description: _group.description,
            notionPageId: _group.notionPageId);
        final updatedGroup = await _repository.getGroup(event.uuid);
        emit(GroupManagementState.success(updatedGroup));
      } catch (e) {
        emit(GroupManagementState.error(e.toString()));
      }
    });
    on<_UpdateDescription>((event, emit) async {
      emit(GroupManagementState.loading());
      try {
        await _repository.modifyGroup(
            uuid: event.uuid,
            name: _group.name,
            description: event.description,
            notionPageId: _group.notionPageId);
        final updatedGroup = await _repository.getGroup(event.uuid);
        emit(GroupManagementState.success(updatedGroup));
      } on Exception catch (e) {
        emit(GroupManagementState.error(e.toString()));
      }
    });
    on<_UpdateNotionLink>((event, emit) async {
      emit(GroupManagementState.loading());
      await _repository.modifyGroup(
        uuid: event.uuid,
        name: _group.name,
        description: _group.description,
        notionPageId: event.notionLink,
      );
      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });
    on<_RemoveMember>((event, emit) async {
      emit(GroupManagementState.loading());
      await _repository.removeMember(
          uuid: event.uuid, targetUuid: event.targetUuid);
      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });
    on<_Delete>((event, emit) async {
      emit(GroupManagementState.loading());
      await _repository.deleteGroup(event.uuid);
      emit(GroupManagementState.done());
    });
    on<_Leave>((event, emit) async {
      emit(GroupManagementState.loading());
      try {
        await _repository.leaveGroup(event.uuid);
        emit(GroupManagementState.done());
      } on Exception {
        emit(GroupManagementState.error(t.group.manage.leave.error));
        return;
      }
    });
  }
}

@freezed
class GroupManagementEvent with _$GroupManagementEvent {
  const factory GroupManagementEvent.load(GroupEntity group) = _Load;

  const factory GroupManagementEvent.updateProfileImage(
      String uuid, File image) = _UpdateProfileImage;
  const factory GroupManagementEvent.updateName(String uuid, String name) =
      _UpdateName;
  const factory GroupManagementEvent.updateDescription(
      String uuid, String description) = _UpdateDescription;
  const factory GroupManagementEvent.updateNotionLink(
      String uuid, String? notionLink) = _UpdateNotionLink;
  const factory GroupManagementEvent.removeMember(
      String uuid, String targetUuid) = _RemoveMember;
  const factory GroupManagementEvent.delete(String uuid) = _Delete;
  const factory GroupManagementEvent.leave(String uuid) = _Leave;
}

@freezed
class GroupManagementState with _$GroupManagementState {
  const GroupManagementState._();

  const factory GroupManagementState.initial() = _Initial;
  const factory GroupManagementState.loading() = _Loading;
  const factory GroupManagementState.success(GroupEntity group) = _Success;
  const factory GroupManagementState.inviteCode(String code) = _InviteCode;
  const factory GroupManagementState.done() = _Done;
  const factory GroupManagementState.error(String message) = _Error;
}
