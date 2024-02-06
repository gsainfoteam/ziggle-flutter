import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/tag_repository.dart';

part 'tag_bloc.freezed.dart';

@injectable
class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository _repository;

  TagBloc(this._repository) : super(const _Initial()) {
    on<_Search>((event, emit) async {
      emit(const TagState.loading());
      final tags = await _repository.searchTags(event.query);
      emit(TagState.loaded(tags));
    });
    on<_Reset>((event, emit) => emit(const TagState.loaded([])));
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
