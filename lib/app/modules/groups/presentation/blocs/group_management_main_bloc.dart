import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_management_main_bloc.freezed.dart';

@injectable
class GroupManagementMainBloc
    extends Bloc<GroupManagementMainBlocEvent, GroupManagementMainBlocState> {
  final GroupRepository _repository;

  GroupManagementMainBloc(this._repository) : super(_Initial()) {
    on<_Load>((event, emit) async {
      emit(_Loading());
      try {
        final groups = await _repository.getGroups();
        emit(_Loaded(groups));
      } on Exception catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}

@freezed
class GroupManagementMainBlocEvent with _$GroupManagementMainBlocEvent {
  const factory GroupManagementMainBlocEvent.started() = _Started;
  const factory GroupManagementMainBlocEvent.load() = _Load;
}

@freezed
class GroupManagementMainBlocState with _$GroupManagementMainBlocState {
  const factory GroupManagementMainBlocState.initial() = _Initial;
  const factory GroupManagementMainBlocState.loading() = _Loading;
  const factory GroupManagementMainBlocState.loaded(GroupListEntity groups) =
      _Loaded;
  const factory GroupManagementMainBlocState.error(String message) = _Error;
}
