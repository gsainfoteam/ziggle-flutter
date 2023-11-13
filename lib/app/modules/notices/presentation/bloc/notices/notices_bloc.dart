import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'notices_bloc.freezed.dart';

@injectable
class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  NoticesBloc() : super(const NoticesState.initial()) {
    on<_Fetch>((event, emit) {});
  }
}

@freezed
class NoticesEvent with _$NoticesEvent {
  const factory NoticesEvent.fetch({
    String? query,
  }) = _Fetch;
}

@freezed
class NoticesState with _$NoticesState {
  const factory NoticesState.initial() = _Initial;
}
