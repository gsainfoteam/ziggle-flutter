import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/ai_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'ai_bloc.freezed.dart';

@injectable
class AiBloc extends Bloc<AiEvent, AiState> {
  final AiRepository _repository;

  AiBloc(this._repository) : super(const _Initial()) {
    on<_Request>((event, emit) async {
      emit(const AiState.loading());
      try {
        final response = await _repository.translate(
          text: event.body,
          targetLang: event.lang,
        );
        emit(AiState.loaded(response));
      } catch (e) {
        emit(AiState.error(e.toString()));
      }
    });
  }
}

@freezed
sealed class AiEvent with _$AiEvent {
  const factory AiEvent.request({
    required String body,
    required AppLocale lang,
  }) = _Request;
}

@freezed
sealed class AiState with _$AiState {
  const AiState._();

  const factory AiState.initial() = _Initial;
  const factory AiState.loading() = _Loading;
  const factory AiState.loaded(String body) = _Loaded;
  const factory AiState.error(String message) = _Error;

  bool get hasResult => this is _Loaded || this is _Error;
}
