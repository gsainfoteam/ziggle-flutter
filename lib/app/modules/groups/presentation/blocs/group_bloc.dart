import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_bloc.freezed.dart';

@injectable
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _repository;

  GroupBloc(this._repository) : super(_Initial()) {
    on<_Load>(_handleLoadOrRefresh);
    on<_Refresh>(_handleLoadOrRefresh);
  }

  void _handleLoadOrRefresh(event, Emitter<GroupState> emit) async {
    emit(_Loading());
    try {
      final groups = await _repository.getGroups();
      emit(_Loaded(groups));
    } on Exception catch (e) {
      emit(_Error(e.toString()));
    }
  }

  static Future<void> refresh(BuildContext context) async {
    final bloc = context.read<GroupBloc>();
    final blocker = bloc.stream.firstWhere((state) => !state.isLoading);
    bloc.add(_Refresh());
    await blocker;
  }
}

@freezed
class GroupEvent with _$GroupEvent {
  const factory GroupEvent.load() = _Load;
  const factory GroupEvent.refresh() = _Refresh;
}

@freezed
class GroupState with _$GroupState {
  const GroupState._();

  const factory GroupState.initial() = _Initial;
  const factory GroupState.loading() = _Loading;
  const factory GroupState.loaded(GroupListEntity groups) = _Loaded;
  const factory GroupState.error(String message) = _Error;

  GroupListEntity? get groups => mapOrNull(loaded: (e) => e.groups);
  bool get isLoading => this is _Loading;
}
