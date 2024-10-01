import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/document_api.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/image_api.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/notice_api.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/tag_api.dart';
import 'package:ziggle/app/modules/notices/data/enums/notice_my.dart';
import 'package:ziggle/app/modules/notices/data/enums/notice_to.dart';
import 'package:ziggle/app/modules/notices/data/models/create_additional_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/create_foreign_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/create_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/get_notices_query_model.dart';
import 'package:ziggle/app/modules/notices/data/models/modify_notice_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_list_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_sort.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';

@Injectable(as: NoticeRepository)
class RestNoticeRepository implements NoticeRepository {
  final NoticeApi _api;
  final TagApi _tagApi;
  final ImageApi _imageApi;
  final DocumentApi _documentApi;

  RestNoticeRepository(
    this._api,
    this._tagApi,
    this._imageApi,
    this._documentApi,
  );

  @override
  Future<NoticeEntity> addAdditionalContent({
    required int id,
    required String content,
    DateTime? deadline,
  }) {
    return _api.addAdditionalContent(
      id,
      CreateAdditionalNoticeModel(
        body: content,
        deadline: deadline,
        to: NoticeTo.all,
      ),
    );
  }

  @override
  Future<NoticeEntity> addReaction(int id, String emoji) {
    return _api.addReaction(id, emoji);
  }

  @override
  Future<void> deleteNotice(int id) {
    return _api.deleteNotice(id);
  }

  @override
  Future<NoticeEntity> getNotice(int id, [bool getAllLanguages = false]) async {
    final notice =
        await _api.getNotice(id, lang: Language.getCurrentLanguage());
    if (getAllLanguages) {
      final langs = notice.langs;
      final notices = await Future.wait(langs.map((lang) async {
        final notice = await _api.getNotice(id, lang: lang);
        return MapEntry(lang, notice);
      }));
      return notice.copyWith(
        langs: langs,
        addedTitles: {
          for (final entry in notices) entry.key: entry.value.title,
        },
        addedContents: {
          for (final entry in notices) entry.key: entry.value.content,
        },
      );
    }
    return notice;
  }

  @override
  Future<NoticeListEntity> getNotices(
      {int? offset,
      int? limit,
      String? search,
      List<String> tags = const [],
      NoticeType type = NoticeType.all}) {
    return _api.getNotices(GetNoticesQueryModel(
      offset: offset,
      limit: limit,
      search: search,
      tags: tags,
      my: NoticeMy.fromType(type),
      orderBy: NoticeSort.fromType(type),
      lang: Language.getCurrentLanguage(),
      category: NoticeCategory.fromType(type),
    ));
  }

  @override
  Future<NoticeEntity> modify(
      {required int id, required String content, DateTime? deadline}) {
    return _api.modifyNotice(
      id,
      ModifyNoticeModel(
        body: content,
        deadline: deadline,
      ),
    );
  }

  @override
  Future<NoticeEntity> removeReaction(int id, String emoji) {
    return _api.removeReaction(id, emoji);
  }

  Future<TagEntity> _createTag(String name) {
    return _tagApi.createTag(name);
  }

  Future<TagEntity?> _getTag(String name) async {
    try {
      return await _tagApi.findTag(name);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<NoticeEntity> write(
      {required String title,
      required String content,
      DateTime? deadline,
      required NoticeType type,
      List<String> tags = const [],
      List<File> images = const [],
      List<File> documents = const []}) async {
    final uploadedTags = await Future.wait(
      tags.map((tag) async {
        final existingTag = await _getTag(tag);
        return existingTag ?? await _createTag(tag);
      }),
    );
    final uploadedImages =
        images.isEmpty ? <String>[] : await _imageApi.uploadImages(images);
    final uploadedDocuments = documents.isEmpty
        ? <String>[]
        : await _documentApi.uploadDocuments(documents);
    return _api.createNotice(CreateNoticeModel(
      title: title,
      body: content,
      deadline: deadline,
      category: NoticeCategory.fromType(type)!,
      tags: uploadedTags.map((tag) => tag.id).toList(),
      images: uploadedImages,
      documents: uploadedDocuments,
    ));
  }

  @override
  Future<NoticeEntity> writeForeign({
    required int id,
    String? title,
    required String content,
    required int contentId,
    required Language lang,
    DateTime? deadline,
  }) async {
    return _api.addForeign(
      id,
      contentId,
      CreateForeignNoticeModel(
        title: title,
        body: content,
        deadline: deadline,
        lang: lang,
      ),
    );
  }

  @override
  Future<NoticeEntity> sendNotification(int id) async {
    await _api.alarm(id);
    return _api.getNotice(id);
  }
}
