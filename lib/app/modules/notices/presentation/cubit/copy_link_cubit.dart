import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_copy_link_repository.dart';

@injectable
class CopyLinkCubit extends Cubit<bool?> {
  final NoticeCopyLinkRepository _repository;

  CopyLinkCubit(this._repository) : super(null);

  Future<bool> copyLink(NoticeEntity notice) async {
    final result = await _repository.copyLink(notice);
    emit(result);
    emit(null);
    return result;
  }
}
