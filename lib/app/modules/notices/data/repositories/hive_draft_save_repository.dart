import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_write_draft_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_draft_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/draft_save_repository.dart';

@Singleton(as: DraftSaveRepository)
class HiveDraftSaveRepository implements DraftSaveRepository {
  static const _boxKey = '_ziggle_4_draft';
  late final Box<NoticeWriteDraftModel> _box;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    Hive.registerAdapter(NoticeWriteDraftModelImplAdapter());
    Hive.registerAdapter(LanguageAdapter());
    Hive.registerAdapter(NoticeTypeAdapter());
    try {
      _box = await Hive.openBox(_boxKey);
    } catch (_) {
      Hive.deleteBoxFromDisk(_boxKey);
      _box = await Hive.openBox(_boxKey);
    }
  }

  @override
  Future<void> deleteDraft() {
    return _box.delete(_boxKey);
  }

  @override
  Future<NoticeWriteDraftEntity?> getDraft() async {
    final draft = _box.get(_boxKey);
    if (draft == null) return null;
    return draft.toEntity();
  }

  @override
  Future<void> saveDraft(NoticeWriteDraftEntity draft) {
    return _box.put(_boxKey, NoticeWriteDraftModel.fromEntity(draft));
  }
}
