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
      : super(GroupManagementState.loading()) {
    on<_updateName>((event, emit) async {
      await _repository.modifyName(uuid: event.uuid, name: event.name);
    });
  }
}

@freezed
class GroupManagementEvent with _$GroupManagementEvent {
  const factory GroupManagementEvent.updateName(String uuid, String name) =
      _updateName;
}

@freezed
class GroupManagementState with _$GroupManagementState {
  const factory GroupManagementState.loading() = _Loading;
}
