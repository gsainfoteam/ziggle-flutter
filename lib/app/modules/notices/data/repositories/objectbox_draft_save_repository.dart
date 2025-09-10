import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/data_sources/object_box.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_write_draft_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/draft_save_repository.dart';
import 'package:ziggle/objectbox.g.dart';

@Singleton(as: DraftSaveRepository)
class ObjectBoxDraftSaveRepository implements DraftSaveRepository {
  final ObjectBox objectBox = sl<ObjectBox>();
  late final Box<NoticeWriteDraftModel> _box;

  @PostConstruct(preResolve: true)
  ObjectBoxDraftSaveRepository() {
    _box = objectBox.store.box<NoticeWriteDraftModel>();
  }

  @override
  Future<void> deleteDraft() async {
    _box.remove(1);
  }

  @override
  Future<NoticeWriteDraftEntity?> getDraft() async {
    return _box.get(1)?.toEntity();
  }

  @override
  Future<void> saveDraft(NoticeWriteDraftEntity draft) async {
    _box.put(NoticeWriteDraftModel.fromEntity(draft).copyWith(id: 1));
  }
}
