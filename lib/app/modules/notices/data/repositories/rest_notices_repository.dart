import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ziggle/app/common/domain/repositories/settings_repository.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/image_api.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/tag_api.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_write_model.dart';
import 'package:ziggle/app/modules/notices/data/models/rest_translation_write_model.dart';
import 'package:ziggle/app/modules/notices/data/models/rest_write_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/tag_model.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_write_entity.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/entities/notice_list_entity.dart';
import '../../domain/entities/notice_search_query_entity.dart';
import '../../domain/entities/notice_summary_entity.dart';
import '../../domain/repositories/notices_repository.dart';
import '../data_sources/notice_api.dart';

const _draftKey = 'notice_write_draft';

@Injectable(as: NoticesRepository)
class RestNoticesRepository implements NoticesRepository {
  final NoticeApi _api;
  final TagApi _tagApi;
  final ImageApi _imageApi;
  final SettingsRepository _settingsRepository;

  RestNoticesRepository(
    this._api,
    this._tagApi,
    this._imageApi,
    this._settingsRepository,
  );

  @override
  Future<void> cancelReminder(NoticeEntity notice) {
    return _api.cancelReminder(notice.id);
  }

  @override
  Future<NoticeEntity> getNotice(NoticeSummaryEntity summary) {
    return _api.getNotice(summary.id);
  }

  @override
  Future<NoticeListEntity> getNotices(NoticeSearchQueryEntity query) {
    return _api.getNotices(
      offset: query.offset,
      limit: query.limit,
      search: query.search,
      tags: query.tags,
      orderBy: query.orderBy,
      my: query.my,
    );
  }

  @override
  Future<void> deleteNotice(NoticeSummaryEntity summary) {
    return _api.deleteNotice(summary.id);
  }

  @override
  Future<void> setReminder(NoticeEntity notice) {
    return _api.setReminder(notice.id);
  }

  Future<TagModel?> _findTag(String tag) async {
    try {
      return await _tagApi.findTag(tag);
    } catch (_) {
      return null;
    }
  }

  Future<List<String>> _uploadImages(Iterable<String> imagePaths) async {
    if (imagePaths.isEmpty) return const [];
    final result = await _imageApi.uploadImages(
      imagePaths.map((e) => File(e)).toList(),
    );
    return result;
  }

  @override
  Future<NoticeEntity> writeNotice(NoticeWriteEntity writing) async {
    final tagSearchResult = await Future.wait(
      writing.tags.map((e) async => MapEntry(e, await _findTag(e))),
    );
    final existTags =
        tagSearchResult.where((e) => e.value != null).map((e) => e.value!.id);
    final requireToCreateTags =
        tagSearchResult.where((e) => e.value == null).map((e) => e.key);
    final createdTags = await Future.wait(
      requireToCreateTags
          .map(_tagApi.createTag)
          .map((e) => e.then((value) => value.id)),
    );

    final imageKeys = await _uploadImages(writing.imagePaths);
    final result = await _api.writeNotice(RestWriteNoticeModel(
      title: writing.title,
      body: writing.body,
      deadline: writing.deadline,
      images: imageKeys,
      tags: [writing.type!.id, ...existTags, ...createdTags],
    ));

    await _settingsRepository.removeSetting(_draftKey);

    return result;
  }

  @override
  Future<NoticeWriteModel?> loadDraft() async {
    return _settingsRepository.getSetting(_draftKey);
  }

  @override
  Future<void> saveDraft(NoticeWriteEntity writing) {
    return _settingsRepository.setSetting(
      _draftKey,
      NoticeWriteModel(
        title: writing.title,
        body: writing.body,
        deadline: writing.deadline,
        tags: writing.tags,
        typeIndex: writing.type?.index,
      ),
    );
  }

  @override
  Future<NoticeEntity> translateNotice(
    NoticeEntity notice,
    String content,
  ) async {
    return _api.translateNotice(
      id: notice.id,
      contentIndex: notice.contents.single.id,
      body: RestTranslationWriteModel(body: content),
    );
  }
}
