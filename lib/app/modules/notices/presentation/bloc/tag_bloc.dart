import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';

part 'tag_bloc.freezed.dart';

Stream<T> _thottle<T>(Stream<T> events, Stream<T> Function(T) mapper) => events
    .throttleTime(const Duration(milliseconds: 500), trailing: true)
    .distinct()
    .switchMap(mapper);

@injectable
class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository _repository;

  TagBloc(this._repository) : super(const _Initial()) {
    on<TagEvent>((event, emit) async {
      if (event is _Search) {
        emit(const TagState.loading());
        final tags = await _repository.searchTags(event.query);
        emit(TagState.loaded(tags));
      } else if (event is _Reset) {
        emit(const TagState.loaded([]));
      }
    }, transformer: _thottle);
  }
}

@freezed
class TagEvent with _$TagEvent {
  const factory TagEvent.search(String query) = _Search;
  const factory TagEvent.reset() = _Reset;
}

@freezed
class TagState with _$TagState {
  const TagState._();
  const factory TagState.initial() = _Initial;
  const factory TagState.loading() = _Loading;
  const factory TagState.loaded(List<TagEntity> tags) = _Loaded;

  bool get loaded => this is _Loaded;
  List<TagEntity> get tags => (this as _Loaded).tags;
}
