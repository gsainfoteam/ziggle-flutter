import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_management_bloc.freezed.dart';

@injectable
class GroupManagementBloc
    extends Bloc<GroupManagementEvent, GroupManagementState> {
  final GroupRepository _repository;

  GroupManagementBloc(this._repository)
      : super(GroupManagementState.initial()) {
    on<_UpdateName>((event, emit) async {
      emit(_Loading());
      await _repository.modifyName(uuid: event.uuid, name: event.name);
      emit(_Done());
    });
    on<_UpdateDescription>((event, emit) async {
      emit(_Loading());
      await _repository.modifyDescription(
          uuid: event.uuid, description: event.description);
      emit(_Done());
    });
    on<_UpdateNotionLink>((event, emit) async {
      emit(_Loading());
      await _repository.modifyNotionLink(
          uuid: event.uuid, notionPageId: event.notionLink);
      emit(_Done());
    });
    on<_CreateInviteLink>((event, emit) async {
      emit(_Loading());
      _repository.deleteGroup(event.uuid);
      emit(_Done());
    });
    on<_GetMembers>((event, emit) async {
      emit(_Loading());
      _repository.getMembers(event.uuid);
      emit(_Done());
    });
    on<_RemoveMember>((event, emit) async {
      emit(_Loading());
      _repository.removeMember(uuid: event.uuid, targetUuid: event.targetUuid);
      emit(_Done());
    });
    on<_GrantRoleToUser>((event, emit) {
      emit(_Loading());
      _repository.grantRoleToUser(
          uuid: event.uuid, targetUuid: event.targetUuid, roleId: event.roleId);
      emit(_Done());
    });
    on<_RemoveRoleFromUser>((event, emit) {
      emit(_Loading());
      _repository.removeRoleFromUser(
          uuid: event.uuid, targetUuid: event.targetUuid, roleId: event.roleId);
      emit(_Done());
    });
    on<_Delete>((event, emit) async {
      emit(_Loading());
      _repository.deleteGroup(event.uuid);
      emit(_Done());
    });
    on<_Leave>((event, emit) async {
      emit(_Loading());
      // _repository.leaveGroup(event.uuid);
      emit(_Done());
    });
  }
}

@freezed
class GroupManagementEvent with _$GroupManagementEvent {
  const factory GroupManagementEvent.updateName(String uuid, String name) =
      _UpdateName;
  const factory GroupManagementEvent.updateDescription(
      String uuid, String? description) = _UpdateDescription;
  const factory GroupManagementEvent.updateNotionLink(
      String uuid, String? notionLink) = _UpdateNotionLink;
  const factory GroupManagementEvent.createInviteLink(String uuid) =
      _CreateInviteLink;
  const factory GroupManagementEvent.getMembers(String uuid) = _GetMembers;
  const factory GroupManagementEvent.removeMember(
      String uuid, String targetUuid) = _RemoveMember;
  const factory GroupManagementEvent.grantRoleToUser(
      String uuid, String targetUuid, int roleId) = _GrantRoleToUser;
  const factory GroupManagementEvent.removeRoleFromUser(
      String uuid, String targetUuid, int roleId) = _RemoveRoleFromUser;
  const factory GroupManagementEvent.delete(String uuid) = _Delete;
  const factory GroupManagementEvent.leave() = _Leave;
}

@freezed
class GroupManagementState with _$GroupManagementState {
  const factory GroupManagementState.initial() = _Initial;
  const factory GroupManagementState.loading() = _Loading;
  const factory GroupManagementState.done() = _Done;
}
