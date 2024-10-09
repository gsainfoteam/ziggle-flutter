import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/groups_api_channel.dart';
import 'package:ziggle/app/modules/core/domain/enums/ziggle_api_channel.dart';
import 'package:ziggle/app/modules/core/domain/repositories/api_channel_repository.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';

part 'developer_option_bloc.freezed.dart';

@injectable
class DeveloperOptionBloc
    extends Bloc<DeveloperOptionEvent, DeveloperOptionState> {
  final DeveloperOptionRepository _repository;
  final ApiChannelRepository _apiChannelRepository;

  DeveloperOptionBloc(this._repository, this._apiChannelRepository)
      : super(_Initial(
          ziggleApiChannel: ZiggleApiChannel.byMode(),
          groupsApiChannel: GroupsApiChannel.byMode(),
        )) {
    on<_Load>((event, emit) async {
      final result = await _repository.getDeveloperOption();
      emit(_Loaded(
        enabled: result,
        ziggleApiChannel: state.ziggleApiChannel,
        groupsApiChannel: state.groupsApiChannel,
      ));
      emit.forEach(_apiChannelRepository.ziggleChannel,
          onData: (ziggleApiChannel) => state.copyWith(
                ziggleApiChannel: ziggleApiChannel,
              ));
      emit.forEach(_apiChannelRepository.groupsChannel,
          onData: (groupsApiChannel) => state.copyWith(
                groupsApiChannel: groupsApiChannel,
              ));
    });
    on<_Enable>((event, emit) async {
      await _repository.setDeveloperOption(true);
      emit(state.copyWith(enabled: true));
    });
    on<_Disable>((event, emit) async {
      await _repository.setDeveloperOption(false);
      emit(state.copyWith(enabled: false));
    });
    on<_ToggleChannel>((event, emit) async {
      final ziggleChannel = _apiChannelRepository.toggleZiggleChannel();
      final groupsChannel = _apiChannelRepository.toggleGroupsChannel();
      emit(state.copyWith(
        ziggleApiChannel: ziggleChannel,
        groupsApiChannel: groupsChannel,
      ));
    });
  }
}

@freezed
sealed class DeveloperOptionEvent {
  const factory DeveloperOptionEvent.load() = _Load;
  const factory DeveloperOptionEvent.enable() = _Enable;
  const factory DeveloperOptionEvent.disable() = _Disable;
  const factory DeveloperOptionEvent.toggleChannel() = _ToggleChannel;
}

@freezed
sealed class DeveloperOptionState with _$DeveloperOptionState {
  const factory DeveloperOptionState.initial({
    @Default(false) bool enabled,
    required ZiggleApiChannel ziggleApiChannel,
    required GroupsApiChannel groupsApiChannel,
  }) = _Initial;
  const factory DeveloperOptionState.loaded({
    required bool enabled,
    required ZiggleApiChannel ziggleApiChannel,
    required GroupsApiChannel groupsApiChannel,
  }) = _Loaded;
}
