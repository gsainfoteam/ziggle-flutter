import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_role_bloc.freezed.dart';

@injectable
class GroupRoleBloc extends Bloc<GroupRoleEvent, GroupRoleState> {
  final GroupRepository _repository;

  GroupRoleBloc(this._repository) : super(_Initial()) {
    on<_Load>((event, emit) async {
      emit(_Loading());
    });
    on<_GetRoles>((event, emit) async {
      emit(GroupRoleState.loading());
      final roles = await _repository.getUserRoleInGroup(event.uuid);
      emit(GroupRoleState.loaded(roles.name));
    });
  }
}

@freezed
class GroupRoleEvent with _$GroupRoleEvent {
  const factory GroupRoleEvent.load() = _Load;
  const factory GroupRoleEvent.getRoles(String uuid) = _GetRoles;
}

@freezed
class GroupRoleState with _$GroupRoleState {
  const GroupRoleState._();

  const factory GroupRoleState.initial() = _Initial;
  const factory GroupRoleState.loading() = _Loading;
  const factory GroupRoleState.loaded(GroupMemberRole roles) = _Loaded;
  const factory GroupRoleState.error(String message) = _Error;
}
