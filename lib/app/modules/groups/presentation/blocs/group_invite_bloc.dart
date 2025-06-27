import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/data/enums/group_member_role.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/repository/group_repository.dart';

part 'group_invite_bloc.freezed.dart';

@injectable
class GroupInviteBloc extends Bloc<GroupInviteEvent, GroupInviteState> {
  final GroupRepository _repository;

  GroupInviteBloc(this._repository) : super(const GroupInviteState.initial()) {
    on<_Create>((event, emit) async {
      emit(const GroupInviteState.loading());
      final inviteLink = await _repository.createInviteLink(
          group: event.group,
          role: GroupMemberRole.member,
          durationDays: Duration(days: event.duration));
      emit(GroupInviteState.success(inviteLink));
    });
  }
}

@freezed
class GroupInviteEvent with _$GroupInviteEvent {
  const factory GroupInviteEvent.create(GroupEntity group, int duration) =
      _Create;
}

@freezed
class GroupInviteState with _$GroupInviteState {
  const factory GroupInviteState.initial() = _Initial;
  const factory GroupInviteState.loading() = _Loading;
  const factory GroupInviteState.success(String inviteCode) = _Success;
}
