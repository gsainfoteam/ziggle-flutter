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
    on<_Load>((event, emit) {
      emit(_Loading());
      return emit.forEach(
        _repository.isSignedIn,
        onData: (v) => v ? const _Authenticated() : const _Unauthenticated(),
      );
    });
    on<_Login>(
      (event, emit) async {
        try {
          emit(_Loading());
          await _repository.login();
          emit(_Authenticated());
        } on Exception catch (e) {
          emit(_Error(e.toString()));
        }
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
  const factory GroupAuthState.loading() = _Loading;
  const factory GroupAuthState.error(String error) = _Error;
  const factory GroupAuthState.unauthenticated() = _Unauthenticated;
  const factory GroupAuthState.authenticated() = _Authenticated;
}
