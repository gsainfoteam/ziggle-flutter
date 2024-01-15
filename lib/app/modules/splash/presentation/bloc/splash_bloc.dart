import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/splash_repository.dart';

part 'splash_bloc.freezed.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepository _repository;
  SplashBloc(this._repository) : super(const SplashState.initial()) {
    on<_Init>((event, emit) async {
      emit(const SplashState.loading());
      try {
        await _repository.init();
        emit(const SplashState.loaded());
      } catch (e) {
        emit(SplashState.error(e.toString()));
      } finally {
        await _repository.remove();
      }
    });
  }
}

@freezed
class SplashEvent with _$SplashEvent {
  const factory SplashEvent.init() = _Init;
}

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = _Initial;
  const factory SplashState.loading() = _Loading;
  const factory SplashState.loaded() = _Loaded;
  const factory SplashState.error(String message) = _Error;
}
