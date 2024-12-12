import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_management_main_bloc.freezed.dart';

@injectable
class GroupManagementMainBloc
    extends Bloc<GroupManagementMainEvent, GroupManagementMainState> {
  final GroupRepository _repository;

  GroupManagementMainBloc(this._repository) : super(_Initial()) {
    on<_Load>(_handleLoadOrRefresh);
    on<_Refresh>(_handleLoadOrRefresh);
  }

  void _handleLoadOrRefresh(
      event, Emitter<GroupManagementMainState> emit) async {
    emit(_Loading());
    try {
      final groups = await _repository.getGroups();
      emit(_Loaded(groups));
    } on Exception catch (e) {
      emit(_Error(e.toString()));
    }
  }

  static Future<void> refresh(BuildContext context) async {
    final bloc = context.read<GroupManagementMainBloc>();
    final blocker = bloc.stream.firstWhere((state) => !state.isLoading);
    bloc.add(_Refresh());
    await blocker;
  }
}

@freezed
class GroupManagementMainEvent with _$GroupManagementMainEvent {
  const factory GroupManagementMainEvent.load() = _Load;
  const factory GroupManagementMainEvent.refresh() = _Refresh;
}

@freezed
class GroupManagementMainState with _$GroupManagementMainState {
  const GroupManagementMainState._();

  const factory GroupManagementMainState.initial() = _Initial;
  const factory GroupManagementMainState.loading() = _Loading;
  const factory GroupManagementMainState.loaded(GroupListEntity groups) =
      _Loaded;
  const factory GroupManagementMainState.error(String message) = _Error;

  GroupListEntity? get groups => mapOrNull(loaded: (e) => e.groups);
  bool get isLoading => this is _Loading;
}
