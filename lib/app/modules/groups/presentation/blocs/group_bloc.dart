import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/remote/group_api.dart';

part 'group_bloc.freezed.dart';

@injectable
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupApi _api;

  GroupBloc(this._api) : super(const _Initial()) {
    //on<_GetAll>((event, emit) => ,)
  }
}

@freezed
sealed class GroupEvent with _$GroupEvent {
  const factory GroupEvent() = _New;
  const factory GroupEvent.getAll() = _GetAll;
}

@freezed
sealed class GroupState with _$GroupState {
  const factory GroupState.initial() = _Initial;
}
