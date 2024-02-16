import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/author_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/entities/notice_list_entity.dart';
import '../../domain/entities/notice_reaction_entity.dart';
import '../../domain/enums/notice_reaction.dart';
import '../../domain/enums/notice_type.dart';
import '../../domain/repositories/notice_repository.dart';

@Injectable(as: NoticeRepository)
@test
class TestNoticeRepository implements NoticeRepository {
  static final _notices = [
    NoticeEntity(
      id: 0,
      views: 0,
      langs: [AppLocale.ko],
      deadline: DateTime.now().add(const Duration(days: 12)),
      currentDeadline: DateTime.now().add(const Duration(days: 12)),
      createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
      deletedAt: null,
      tags: ['행사', '전시회', '디지털콘텐츠'],
      title: '✨ 디지털 콘텐츠 전시회 2023 - illuminate✨',
      content:
          "융합기술제학부의 '디지털 콘텐츠 전시', '서비스러닝프로젝트' 등 수업의 한 학기 최종 결과물을 모아 전시합니다!\n\n"
          "지스트 학부생, 대학원생이 참여한 다양한 형태의 멋진 디지털 작품이 여러분을 기다리고 있습니다.\n\n"
          "많은 관심 부탁드립니다.",
      additionalContents: [],
      reactions: [
        NoticeReactionEntity(
          emoji: NoticeReaction.like.emoji,
          count: 67,
          isReacted: false,
        )
      ],
      author: AuthorEntity(name: '홍길동', uuid: ''),
      imageUrls: [
        'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-12-04T10:29:08.088Z-f18xicwm4kr.webp',
        'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-12-04T10:29:08.091Z-1nju8u8ryik.webp',
        'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-12-04T10:29:08.092Z-w0ew7udgmlc.webp',
      ],
      documentUrls: [],
      isReminded: false,
    ),
    NoticeEntity(
      id: 0,
      views: 0,
      langs: [AppLocale.ko],
      deadline: null,
      currentDeadline: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      deletedAt: null,
      tags: ['행사', '전시회', '디지털콘텐츠'],
      title: '제휴업체 댓글 이벤트 당첨자 공지',
      content:
          "융합기술제학부의 '디지털 콘텐츠 전시', '서비스러닝프로젝트' 등 수업의 한 학기 최종 결과물을 모아 전시합니다!\n\n"
          "지스트 학부생, 대학원생이 참여한 다양한 형태의 멋진 디지털 작품이 여러분을 기다리고 있습니다.\n\n"
          "많은 관심 부탁드립니다.",
      additionalContents: [],
      reactions: [
        NoticeReactionEntity(
          emoji: NoticeReaction.like.emoji,
          count: 67,
          isReacted: false,
        )
      ],
      author: AuthorEntity(name: '홍길동', uuid: ''),
      imageUrls: [
        'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-11-23T14:06:36.786Z-xp0hj6dobvm.webp',
        'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-11-23T14:06:36.790Z-moiqsx43j4.webp',
      ],
      documentUrls: [],
      isReminded: false,
    ),
  ];

  @override
  Future<NoticeEntity> addAdditionalContent(
      {required int id,
      required String content,
      DateTime? deadline,
      bool? notifyToAll}) async {
    return _notices[0];
  }

  @override
  Future<NoticeEntity> addReaction(int id, String emoji) async {
    return _notices[0];
  }

  @override
  Future<NoticeEntity> addReminder(int id) async {
    return _notices[0];
  }

  @override
  Future<void> deleteNotice(int id) async {}

  @override
  Future<NoticeEntity> getNotice(int id) async {
    return _notices[0];
  }

  @override
  Future<NoticeListEntity> getNotices(
      {int? offset,
      int? limit,
      String? search,
      List<String> tags = const [],
      NoticeType type = NoticeType.all}) async {
    return NoticeListEntity(total: 2, list: _notices);
  }

  @override
  Future<NoticeEntity> removeReaction(int id, String emoji) async {
    return _notices[0];
  }

  @override
  Future<NoticeEntity> removeReminder(int id) async {
    return _notices[0];
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
    return _notices[0];
  }

  @override
  Future<NoticeEntity> writeForeign(
      {required int id,
      String? title,
      required String content,
      required int contentId,
      required AppLocale lang,
      DateTime? deadline}) async {
    return _notices[0];
  }
}
