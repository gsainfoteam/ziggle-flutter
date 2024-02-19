import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/entities/notice_list_entity.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';
import '../data_sources/remote/document_api.dart';
import '../data_sources/remote/image_api.dart';
import '../data_sources/remote/notice_api.dart';
import '../data_sources/remote/tag_api.dart';
import '../enums/notice_my.dart';
import '../enums/notice_to.dart';
import '../models/create_additional_notice_model.dart';
import '../models/create_foreign_notice_model.dart';
import '../models/create_notice_model.dart';

@Injectable(as: NoticeRepository)
@prod
@dev
class RemoteNoticeRepository implements NoticeRepository {
  final NoticeApi _api;
  final TagApi _tagApi;
  final ImageApi _imageApi;
  final DocumentApi _documentApi;

  RemoteNoticeRepository(
    this._api,
    this._tagApi,
    this._imageApi,
    this._documentApi,
  );

  @override
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String> tags = const [],
    NoticeType type = NoticeType.all,
  }) {
    return _api.getNotices(
      offset: offset,
      limit: limit,
      search: search,
      tags: [if (type.isTag) type.name, ...tags],
      lang: LocaleSettings.currentLocale,
      orderBy: type.defaultSort,
      my: NoticeMy.fromType(type),
    );
  }

  @override
  Future<NoticeEntity> getNotice(int id) {
    return _api.getNotice(
      id,
      lang: LocaleSettings.currentLocale,
      isViewed: true,
    );
  }

  @override
  Future<NoticeEntity> addReaction(int id, String emoji) {
    return _api.addReaction(id, emoji);
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
  Future<NoticeEntity> write({
    required String title,
    required String content,
    DateTime? deadline,
    required NoticeType type,
    List<String> tags = const [],
    List<File> images = const [],
    List<File> documents = const [],
  }) async {
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
    return _api.createNotice(
      CreateNoticeModel(
        title: title,
        body: content,
        deadline: deadline,
        tags: [type.tagId, ...uploadedTags.map((tag) => tag.id)],
        images: uploadedImages,
        documents: uploadedDocuments,
      ),
    );
  }

  @override
  Future<NoticeEntity> addReminder(int id) {
    return _api.addReminder(id);
  }

  @override
  Future<NoticeEntity> removeReminder(int id) {
    return _api.removeReminder(id);
  }

  @override
  Future<void> deleteNotice(int id) {
    return _api.deleteNotice(id);
  }

  @override
  Future<NoticeEntity> addAdditionalContent({
    required int id,
    required String content,
    DateTime? deadline,
    bool? notifyToAll,
  }) {
    return _api.addAdditionalContent(
      id,
      CreateAdditionalNoticeModel(
        body: content,
        deadline: deadline,
        to: NoticeTo.fromBoolean(notifyToAll ?? false),
      ),
    );
  }

  @override
  Future<NoticeEntity> writeForeign({
    required int id,
    String? title,
    required String content,
    required int contentId,
    required AppLocale lang,
    DateTime? deadline,
  }) {
    return _api.addForeign(
      id,
      contentId,
      CreateForeignNoticeModel(
        title: title,
        body: content,
        lang: lang,
        deadline: deadline,
      ),
    );
  }

  @override
  Future<NoticeEntity> modify(
      {required int id,
      String? title,
      String? content,
      DateTime? deadline,
      NoticeType? type,
      List<String>? tags,
      List<String>? prevImages,
      List<File>? images,
      List<File>? documents}) {
    // TODO: implement modify
    throw UnimplementedError();
  }
}
