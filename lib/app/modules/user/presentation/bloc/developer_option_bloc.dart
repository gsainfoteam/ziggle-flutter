import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';
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
          apiChannel: ApiChannel.byMode(),
        )) {
    on<_Load>((event, emit) async {
      final result = await _repository.getDeveloperOption();
      emit(_Loaded(
        enabled: result,
        apiChannel: state.apiChannel,
      ));
      return emit.forEach(_apiChannelRepository.channel,
          onData: (channel) => state.copyWith(
                apiChannel: channel,
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
      final channel = _apiChannelRepository.toggleChannel();
      emit(state.copyWith(
        apiChannel: channel,
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
    required ApiChannel apiChannel,
  }) = _Initial;
  const factory DeveloperOptionState.loaded({
    required bool enabled,
    required ApiChannel apiChannel,
  }) = _Loaded;
}
