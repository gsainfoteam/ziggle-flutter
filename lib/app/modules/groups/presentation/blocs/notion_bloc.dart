import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/repository/notion_repository.dart';

part 'notion_bloc.freezed.dart';

@injectable
class NotionBloc extends Bloc<NotionEvent, NotionState> {
  final NotionRepository _repository;

  NotionBloc(this._repository) : super(const NotionState.initial()) {
    on<_Load>((event, emit) => _loadNotionPage(emit, event.pageId));
  }

  Future<void> _loadNotionPage(
    Emitter<NotionState> emit,
    String pageId,
  ) async {
    emit(const NotionState.loading());
    try {
      final data = await _repository.getGroups(pageId);
      emit(NotionState.done(data));
    } catch (e) {
      emit(NotionState.error(e.toString()));
    }
  }
}

@freezed
class NotionEvent with _$NotionEvent {
  const factory NotionEvent.load({required String pageId}) = _Load;
}

@freezed
class NotionState with _$NotionState {
  const factory NotionState.initial() = _Initial;
  const factory NotionState.loading() = _Loading;
  const factory NotionState.done(Map<String, dynamic> data) = _Done;
  const factory NotionState.error(String message) = _Error;
}
