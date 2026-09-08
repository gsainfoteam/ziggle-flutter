import 'package:cached_network_image/cached_network_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_group_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';

import 'author_model.dart';
import 'notice_content_model.dart';
import 'notice_reaction_model.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
sealed class NoticeModel with _$NoticeModel implements NoticeEntity {
  const NoticeModel._();

  const factory NoticeModel({
    required int id,
    required int views,
    @Default([Language.ko]) List<Language> langs,
    DateTime? deadline,
    DateTime? currentDeadline,
    required DateTime createdAt,
    DateTime? deletedAt,
    @Default([]) List<String> tags,
    required String title,
    required String content,
    Map<Language, String>? addedTitles,
    Map<Language, String>? addedContents,
    @Default([]) List<NoticeContentModel> additionalContents,
    required List<NoticeReactionModel> reactions,
    required AuthorModel author,
    @Default([]) List<String> imageUrls,
    @Default([]) List<Map<String, String>> documents, // 기존 documentUrls은 안쓰던 값
    @Default(false) bool isReminded,
    required NoticeCategory category,
    NoticeGroupEntity? group,
    required DateTime publishedAt,
    @Default("") String crawledUrl,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
  @override
  List<CachedNetworkImageProvider> get images =>
      imageUrls.map((e) => CachedNetworkImageProvider(e)).toList();

  @override
  Map<Language, String> get titles =>
      addedTitles ?? {Language.getCurrentLanguage(): title};

  @override
  Map<Language, String> get contents =>
      addedContents ?? {Language.getCurrentLanguage(): content};
}

// {
//   "createdAt": "2026-10-08T00:00:00.000Z",
//   "views": 3,
//   "documents": [
//     {
//       "url": "https://www.gist.ac.kr/kr/html/sub05/050209.html?mode=D&no=224007&file_id=84413",
//       "name": "【붙임】 2026. 하반기 은평구민 장학생 선발 공고.pdf"
//     }
//   ],
//   "crawledUrl": "https://www.gist.ac.kr/kr/html/sub05/050209.html?mode=V&no=224007&GotoPage=1"
// }
