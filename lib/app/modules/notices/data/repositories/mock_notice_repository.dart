import 'dart:io';

import 'package:injectable/injectable.dart';
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
  List<NoticeEntity> get _notices => [
        NoticeEntity.mock(
          deadline: DateTime.now().add(const Duration(days: 13)),
          createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
          tags: ['행사', '전시회', '디지털콘텐츠'],
          title: '✨ 디지털 콘텐츠 전시회 2023 - illuminate✨',
          content:
              "융합기술제학부의 '디지털 콘텐츠 전시', '서비스러닝프로젝트' 등 수업의 한 학기 최종 결과물을 모아 전시합니다!"
              "지스트 학부생, 대학원생이 참여한 다양한 형태의 멋진 디지털 작품이 여러분을 기다리고 있습니다."
              "많은 관심 부탁드립니다.",
          reactions: [
            NoticeReactionEntity(
              emoji: NoticeReaction.like.emoji,
              count: 67,
              isReacted: false,
            )
          ],
          imageUrls: [
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-12-04T10:29:08.088Z-f18xicwm4kr.webp',
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-12-04T10:29:08.091Z-1nju8u8ryik.webp',
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-12-04T10:29:08.092Z-w0ew7udgmlc.webp',
          ],
          isReminded: false,
        ),
        NoticeEntity.mock(
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          tags: ['행사', '총학생회', '제휴업체', '협력국'],
          title: '제휴업체 댓글 이벤트 당첨자 공지',
          content: '안녕하세요, GIST 총학생회 집행위원회 협력국입니다😄'
              '제휴업체 댓글 이벤트의 당첨자를 발표합니다!'
              '‼️당첨되신 분들은 11월 25일 토요일 까지 DM으로 전송될 개인정보동의서를 제출해주시기 바랍니다.',
          reactions: [
            NoticeReactionEntity(
              emoji: NoticeReaction.like.emoji,
              count: 23,
              isReacted: false,
            )
          ],
          imageUrls: [
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-11-23T14:06:36.786Z-xp0hj6dobvm.webp',
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-11-23T14:06:36.790Z-moiqsx43j4.webp',
          ],
          isReminded: false,
        ),
        NoticeEntity.mock(
          createdAt: DateTime(2023, 2, 23, 9),
          tags: ['모집', '인포팀'],
          title: '인포팀(정보국) 2023년도 신규 부원 모집',
          content: '[🐈 인포팀(정보국) 2023년도 신규 부원 모집 🐈]'
              '💫 인포팀 소개 페이지'
              '💫 인포팀 서류 접수 페이지'
              "서류 접수 시 'AMS가 처음이 아니신가요?' 버튼은 무시하셔도 됩니다!",
          reactions: [
            NoticeReactionEntity(
              emoji: NoticeReaction.like.emoji,
              count: 52,
              isReacted: false,
            )
          ],
          authorName: '인포팀',
          imageUrls: [
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-07-27T23:19:55.017Z-image_picker_3D389518-EFB4-43C5-8EDF-677A1A1B892B-243-0000018C0A8762FA.webp',
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-07-27T23:19:55.031Z-image_picker_68076261-3893-490F-9588-2D86587C15A0-243-0000018C0A7B89C2.webp',
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-07-27T23:19:55.032Z-image_picker_37229A5A-D2EA-41E5-84CF-493FC055ED50-243-0000018C0A70FCAA.webp',
            'https://s3.ap-northeast-2.amazonaws.com/gsainfoteam-ziggle-notice-images-production/2023-07-27T23:19:55.033Z-image_picker_B9B22822-C9FB-4D37-928F-B2DBE799CADA-243-0000018C0A9C6833.webp',
          ],
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

  @override
  Future<NoticeEntity> modify({
    required int id,
    required String content,
    DateTime? deadline,
  }) async {
    return _notices[0];
  }
}
