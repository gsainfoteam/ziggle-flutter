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
    on<_Delete>((event, emit) async {
      emit(_Loading());
      _repository.deleteGroup(event.uuid);
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
  const factory GroupManagementEvent.delete(String uuid) = _Delete;
  const factory GroupManagementEvent.leave() = _Leave;
}

@freezed
class GroupManagementState with _$GroupManagementState {
  const factory GroupManagementState.initial() = _Initial;
  const factory GroupManagementState.loading() = _Loading;
  const factory GroupManagementState.done() = _Done;
}
