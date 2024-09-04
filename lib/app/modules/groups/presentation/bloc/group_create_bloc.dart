import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'group_create_bloc.freezed.dart';

@injectable
class GroupCreateBloc extends Bloc<GroupCreateEvent, GroupCreateState> {
  GroupCreateBloc() : super(const _Draft()) {
    on<_ChangeEvent>((event, emit) => emit(state));
  }
}

mixin _ChangeEvent implements GroupCreateEvent {}

@freezed
class GroupCreateEvent with _$GroupCreateEvent {
  @With<_ChangeEvent>()
  const factory GroupCreateEvent.changeName(String name) = _ChangeName;
}

@freezed
class GroupCreateState {
  const factory GroupCreateState.draft() = _Draft;
}
