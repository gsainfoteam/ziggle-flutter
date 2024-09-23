import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/domain/repositories/developer_option_repository.dart';

part 'developer_option_bloc.freezed.dart';

@injectable
class DeveloperOptionBloc
    extends Bloc<DeveloperOptionEvent, DeveloperOptionState> {
  final DeveloperOptionRepository _repository;
  DeveloperOptionBloc(this._repository) : super(const _Initial()) {
    on<_Load>((event, emit) async {
      final result = await _repository.getDeveloperOption();
      emit(_Loaded(result));
    });
    on<_Enable>((event, emit) async {
      await _repository.setDeveloperOption(true);
      emit(const _Loaded(true));
    });
    on<_Disable>((event, emit) async {
      await _repository.setDeveloperOption(false);
      emit(const _Loaded(false));
    });
  }
}

@freezed
sealed class DeveloperOptionEvent {
  const factory DeveloperOptionEvent.load() = _Load;
  const factory DeveloperOptionEvent.enable() = _Enable;
  const factory DeveloperOptionEvent.disable() = _Disable;
}

@freezed
sealed class DeveloperOptionState with _$DeveloperOptionState {
  const factory DeveloperOptionState.initial([@Default(false) bool enabled]) =
      _Initial;
  const factory DeveloperOptionState.loaded(bool enabled) = _Loaded;
}
