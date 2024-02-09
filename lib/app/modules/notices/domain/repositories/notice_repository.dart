import 'dart:io';

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
  Future<void> deleteNotice(int id);
}
