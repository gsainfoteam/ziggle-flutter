import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';

abstract class DraftSaveRepository {
  Future<void> saveDraft(NoticeWriteDraftEntity draft);
  Future<void> deleteDraft();
  Future<NoticeWriteDraftEntity?> getDraft();
}
