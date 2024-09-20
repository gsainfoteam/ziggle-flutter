import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'group_bloc.freezed.dart';

@injectable
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(const _Initial());
}

@freezed
sealed class GroupEvent with _$GroupEvent {
  const factory GroupEvent() = _New;
}

@freezed
sealed class GroupState with _$GroupState {
  const factory GroupState.initial() = _Initial;
}
