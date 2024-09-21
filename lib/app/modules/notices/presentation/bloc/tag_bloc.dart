import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/common/presentation/utils/reactive.dart';
import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/tag_repository.dart';

part 'tag_bloc.freezed.dart';

@injectable
class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository _repository;

  TagBloc(this._repository) : super(const TagState.initial()) {
    on<TagEvent>((event, emit) async {
      switch (event) {
        case _Reset _:
          emit(const TagState.initial());
          break;
        case _Search(:final search):
          emit(const TagState.loading());
          final tags = await _repository.searchTags(search);
          emit(TagState.loaded(tags));
          break;
      }
    }, transformer: makeEventThrottler());
  }
}

@freezed
sealed class TagEvent {
  const factory TagEvent.reset() = _Reset;
  const factory TagEvent.search(String search) = _Search;
}

@freezed
sealed class TagState with _$TagState {
  const TagState._();
  const factory TagState.initial() = _Initial;
  const factory TagState.loading() = _Loading;
  const factory TagState.loaded(List<TagEntity> tags) = _Loaded;

  bool get hasResult => this is _Loaded;
  List<TagEntity> get tags => hasResult ? (this as _Loaded).tags : [];
}
