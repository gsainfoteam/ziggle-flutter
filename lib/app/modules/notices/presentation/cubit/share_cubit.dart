import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_share_repository.dart';

@injectable
class ShareCubit extends Cubit<bool?> {
  final NoticeShareRepository _repository;

  ShareCubit(this._repository) : super(null);

  Future<void> share(NoticeEntity notice) async {
    final result = await _repository.shareNotice(notice);
    emit(result);
    emit(null);
  }
}
