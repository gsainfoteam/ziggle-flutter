import 'dart:io';

import 'package:ziggle/gen/strings.g.dart';

import '../entities/notice_entity.dart';
import '../entities/notice_list_entity.dart';
import '../enums/notice_type.dart';

abstract class NoticeRepository {
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String> tags = const [],
    NoticeType type = NoticeType.all,
  });

  Future<NoticeEntity> getNotice(int id);

  Future<NoticeEntity> addReaction(int id, String emoji);
  Future<NoticeEntity> removeReaction(int id, String emoji);
  Future<NoticeEntity> addReminder(int id);
  Future<NoticeEntity> removeReminder(int id);

  Future<NoticeEntity> write({
    required String title,
    required String content,
    DateTime? deadline,
    required NoticeType type,
    List<String> tags = const [],
    List<File> images = const [],
    List<File> documents = const [],
  });
  Future<NoticeEntity> modify({
    required int id,
    required String content,
    DateTime? deadline,
  });
  Future<void> deleteNotice(int id);
  Future<NoticeEntity> addAdditionalContent({
    required int id,
    required String content,
    DateTime? deadline,
    bool? notifyToAll,
  });
  Future<NoticeEntity> writeForeign({
    required int id,
    String? title,
    required String content,
    required int contentId,
    required AppLocale lang,
    DateTime? deadline,
  });
}
