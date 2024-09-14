import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/notice_api.dart';
import 'package:ziggle/app/modules/notices/data/enums/notice_my.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_list_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_sort.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

@Injectable(as: NoticeRepository)
class RestNoticeRepository implements NoticeRepository {
  final NoticeApi _api;

  RestNoticeRepository(this._api);

  @override
  Future<NoticeEntity> addAdditionalContent(
      {required int id,
      required String content,
      DateTime? deadline,
      bool? notifyToAll}) {
    throw UnimplementedError();
  }

  @override
  Future<NoticeEntity> addReaction(int id, String emoji) {
    // TODO: implement addReaction
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNotice(int id) {
    // TODO: implement deleteNotice
    throw UnimplementedError();
  }

  @override
  Future<NoticeEntity> getNotice(int id) {
    // TODO: implement getNotice
    throw UnimplementedError();
  }

  @override
  Future<NoticeListEntity> getNotices(
      {int? offset,
      int? limit,
      String? search,
      List<String> tags = const [],
      NoticeType type = NoticeType.all}) {
    return _api.getNotices(
      offset: offset,
      limit: limit,
      search: search,
      tags: tags,
      my: type == NoticeType.written ? NoticeMy.own : null,
      orderBy: NoticeSort.recent,
    );
  }

  @override
  Future<NoticeEntity> modify(
      {required int id, required String content, DateTime? deadline}) {
    // TODO: implement modify
    throw UnimplementedError();
  }

  @override
  Future<NoticeEntity> removeReaction(int id, String emoji) {
    // TODO: implement removeReaction
    throw UnimplementedError();
  }

  @override
  Future<NoticeEntity> write(
      {required String title,
      required String content,
      DateTime? deadline,
      required NoticeType type,
      List<String> tags = const [],
      List<File> images = const [],
      List<File> documents = const []}) {
    // TODO: implement write
    throw UnimplementedError();
  }

  @override
  Future<NoticeEntity> writeForeign(
      {required int id,
      String? title,
      required String content,
      required int contentId,
      required AppLocale lang,
      DateTime? deadline}) {
    // TODO: implement writeForeign
    throw UnimplementedError();
  }
}
