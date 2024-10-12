import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_rest_auth_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/rest_auth_repository.dart';

part 'group_auth_bloc.freezed.dart';

@injectable
class GroupAuthBloc extends Bloc<GroupAuthEvent, GroupAuthState> {
  final RestAuthRepository _repository;

  GroupAuthBloc(@Named.from(GroupsRestAuthRepository) this._repository)
      : super(const GroupAuthState.initial()) {
    on<_Load>((event, emit) {});
    on<_Login>(
      (event, emit) async {
        await _repository.login();
      },
    );
  }
}

@freezed
sealed class GroupAuthEvent with _$GroupAuthEvent {
  const factory GroupAuthEvent.load() = _Load;
  const factory GroupAuthEvent.login() = _Login;
}

@freezed
sealed class GroupAuthState with _$GroupAuthState {
  const factory GroupAuthState.initial() = _Initial;
}
