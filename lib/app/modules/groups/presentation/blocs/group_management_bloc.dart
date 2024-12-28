import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_management_bloc.freezed.dart';

@injectable
class GroupManagementBloc
    extends Bloc<GroupManagementEvent, GroupManagementState> {
  final GroupRepository _repository;

  GroupManagementBloc(this._repository)
      : super(GroupManagementState.initial()) {
    on<_Load>((event, emit) async {
      emit(GroupManagementState.loading());
      final fetchedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.loaded(fetchedGroup));
    });

    on<_UpdateName>((event, emit) async {
      emit(GroupManagementState.loading());
      try {
        print(event.uuid);
        await _repository.modifyName(uuid: event.uuid, name: event.name);
        final updatedGroup = await _repository.getGroup(event.uuid);
        print(updatedGroup);
        emit(GroupManagementState.success(updatedGroup));
      } catch (e) {
        emit(GroupManagementState.error(e.toString()));
      }
    });

    on<_UpdateDescription>((event, emit) async {
      emit(GroupManagementState.loading());

      await _repository.modifyDescription(
        uuid: event.uuid,
        description: event.description,
      );

      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });

    on<_UpdateNotionLink>((event, emit) async {
      emit(GroupManagementState.loading());

      await _repository.modifyNotionLink(
        uuid: event.uuid,
        notionPageId: event.notionLink,
      );

      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });

    on<_CreateInviteLink>((event, emit) async {
      // 예시로만 남겨둠(기존 코드에서 로직이 좀 어색)
      emit(GroupManagementState.loading());
      // repository 측에서 실제 "createInviteLink"를 구현해야 함
      // 여긴 deleteGroup 호출하고 있어서 수정 요망
      // _repository.deleteGroup(event.uuid);
      // emit(GroupManagementState.success(state.group));

      // 예: 초대 링크를 생성한 뒤, 다시 fetch:
      // final newLink = await _repository.createInviteLink(event.uuid);
      // final updatedGroup = state.group.copyWith(inviteLink: newLink);
      // emit(GroupManagementState.success(updatedGroup));
    });

    on<_GetMembers>((event, emit) async {
      emit(GroupManagementState.loading());

      // 멤버 가져오기 (repository.getMembers 등)
      final members = await _repository.getMembers(event.uuid);

      // 보통 group 내에 멤버 리스트가 있다면 copyWith로 업데이트
      // final updatedGroup = state.group.copyWith(members: members);
      // emit(GroupManagementState.success(updatedGroup));
    });

    on<_RemoveMember>((event, emit) async {
      emit(GroupManagementState.loading());

      await _repository.removeMember(
        uuid: event.uuid,
        targetUuid: event.targetUuid,
      );

      // 다시 fetch or copyWith
      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });

    on<_GrantRoleToUser>((event, emit) async {
      emit(GroupManagementState.loading());

      await _repository.grantRoleToUser(
        uuid: event.uuid,
        targetUuid: event.targetUuid,
        roleId: event.roleId,
      );

      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });

    on<_RemoveRoleFromUser>((event, emit) async {
      emit(GroupManagementState.loading());

      await _repository.removeRoleFromUser(
        uuid: event.uuid,
        targetUuid: event.targetUuid,
        roleId: event.roleId,
      );

      final updatedGroup = await _repository.getGroup(event.uuid);
      emit(GroupManagementState.success(updatedGroup));
    });

    on<_Delete>((event, emit) async {
      emit(GroupManagementState.loading());
      await _repository.deleteGroup(event.uuid);
    });

    on<_Leave>((event, emit) async {
      emit(GroupManagementState.loading());
      await _repository.leaveGroup(event.uuid);
      // emit(GroupManagementState.success))
    });
  }
}

@freezed
class GroupManagementEvent with _$GroupManagementEvent {
  const factory GroupManagementEvent.load(String uuid) = _Load;

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
  const factory GroupManagementEvent.leave(String uuid) = _Leave;
}

@freezed
class GroupManagementState with _$GroupManagementState {
  const factory GroupManagementState.initial() = _Initial;
  const factory GroupManagementState.loading() = _Loading;
  const factory GroupManagementState.loaded(GroupEntity group) = _Loaded;
  const factory GroupManagementState.success(GroupEntity group) = _Done;
  const factory GroupManagementState.error(String message) = _Error;
}
