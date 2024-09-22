import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

EventTransformer<E> makeEventThrottler<E>(
    [Duration duration = const Duration(milliseconds: 500)]) {
  return (events, mapper) => events
      .throttleTime(duration, trailing: true)
      .distinct()
      .switchMap(mapper);
}
