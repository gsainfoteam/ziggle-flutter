import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/groups/domain/repository/notion_repository.dart';
import 'package:ziggle/gen/strings.g.dart';
part 'notion_bloc.freezed.dart';

@injectable
class NotionBloc extends Bloc<NotionEvent, NotionState> {
  final NotionRepository _repository;

  NotionBloc(this._repository) : super(const NotionState.initial()) {
    on<_Edit>((event, emit) => emit(const NotionState.loading()));
    on<_Load>((event, emit) async {
      emit(const NotionState.loading());
      final notionLink = event.notionLink;
      if (notionLink.isEmpty) {
        emit(NotionState.error(t.group.manage.notionLink.loading));
        return;
      }
      try {
        RegExp regex = RegExp(r'([a-f0-9]{32})');
        Match? notionId = regex.firstMatch(notionLink);
        if (notionId != null) {
          final data = await _repository.getGroups(notionId.group(0)!);
          emit(NotionState.done(data));
        } else {
          emit(NotionState.error(t.group.manage.notionLink.error));
        }
      } catch (e) {
        emit(NotionState.error(e.toString()));
      }
    });
  }
}

@freezed
class NotionEvent with _$NotionEvent {
  const factory NotionEvent.load({required String notionLink}) = _Load;
  const factory NotionEvent.edit() = _Edit;
}

@freezed
class NotionState with _$NotionState {
  const factory NotionState.initial() = _Initial;
  const factory NotionState.loading() = _Loading;
  const factory NotionState.done(Map<String, dynamic> data) = _Done;
  const factory NotionState.error(String message) = _Error;
}
