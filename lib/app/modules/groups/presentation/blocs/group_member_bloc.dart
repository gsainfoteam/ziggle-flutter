import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_member_bloc.freezed.dart';

@injectable
class GroupMemberBloc extends Bloc<GroupMemberEvent, GroupMemberState> {
  final GroupRepository _repository;

  GroupMemberBloc(this._repository) : super(_Initial()) {
    on<_Load>((event, emit) {
      emit(_Loading());
    });
    on<_GetMembers>((event, emit) async {
      emit(GroupMemberState.loading());
      final members = await _repository.getMembers(event.uuid);
      emit(GroupMemberState.loaded(members.list));
    });
    on<_RemoveMember>((event, emit) async {
      emit(GroupMemberState.loading());
      await _repository.removeMember(
        uuid: event.uuid,
        targetUuid: event.targetUuid,
      );
      emit(GroupMemberState.success());
    });
    on<_GrantRoleToUser>((event, emit) async {
      emit(GroupMemberState.loading());
      try {
        await _repository.removeRoleFromUser(
          uuid: event.uuid,
          targetUuid: event.targetUuid,
          roleId: event.previousRole.toInt(),
        );
        await _repository.grantRoleToUser(
          uuid: event.uuid,
          targetUuid: event.targetUuid,
          roleId: event.role.toInt(),
        );
      } on Exception catch (e) {
        emit(_Error(e.toString()));
      }
      emit(GroupMemberState.success());
      add(GroupMemberEvent.getMembers(event.uuid));
    });
  }
}

@freezed
class GroupMemberEvent with _$GroupMemberEvent {
  const factory GroupMemberEvent.load() = _Load;
  const factory GroupMemberEvent.getMembers(String uuid) = _GetMembers;
  const factory GroupMemberEvent.removeMember(String uuid, String targetUuid) =
      _RemoveMember;
  const factory GroupMemberEvent.grantRoleToUser(String uuid, String targetUuid,
      GroupMemberRole role, GroupMemberRole previousRole) = _GrantRoleToUser;
}

@freezed
class GroupMemberState with _$GroupMemberState {
  const factory GroupMemberState.initial() = _Initial;
  const factory GroupMemberState.loading() = _Loading;
  const factory GroupMemberState.loaded(List<MemberEntity> list) = _Loaded;
  const factory GroupMemberState.success() = _Success;
  const factory GroupMemberState.error(String error) = _Error;
}
