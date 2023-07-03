import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

part 'article_response.freezed.dart';
part 'article_response.g.dart';

@Freezed()
class ArticleResponse with _$ArticleResponse {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.none)
  const factory ArticleResponse({
    required int id,
    required String title,
    required int views,
    required String body,
    DateTime? deadline,
    required DateTime createdAt,
    List<String>? imagesUrl,
    @Default([]) List<TagResponse> tags,
    @JsonKey(name: 'notExistKeyTemporary')
    @Default(placeholderUserName)
    String author,
  }) = _ArticleResponse;

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleResponseFromJson(json);

  factory ArticleResponse.sample(int maxPage) => ArticleResponse(
        id: 1,
        title: '[하우스연합회🏠] 중고장터 물품 접수안내',
        views: 120,
        author: placeholderUserName,
        tags: const [
          TagResponse(id: 0, name: '자일리톨스톤'),
          TagResponse(id: 0, name: '자일리톨돌'),
          TagResponse(id: 0, name: '돌'),
        ],
        body: '''안녕하세요, 하우스연합회입니다.<br>
<br>
작년에 진행한 CCTV 설치 설문조사 결과를 바탕으로, 공용공간 도난 및 이성층 출입을 방지하기 위해 CCTV 설치를 최종 결정하였습니다. <br>
이와 관련된 내용은 다음과 같습니다.<br>
<br>
<h3>🔥 WING에서는...</h3>
현재 여러 분야의 개발/프로그래밍 및 현업 경험이 있는 시니어 팀이 존재하며, 올해 새롭게 주니어 팀을 선발하고자 합니다!

<h3>🔥 WING의 올해 키워드 : “빠른 성장”, “전문성”</h3>
빠르게 성장하고 싶은 개발자가 되고 싶다면, 망설이지 말고 WING에 지원해보세요!!

<h3>🔥 WING의 선발 방식</h3>
일반적인 서류/면접 전형이 아닌 올해 새로운 선발 방식을 도입했으므로, 자세한 사항은 밑 노션 소개페이지를 참고해주세요!! <br>
<a href="https://jaehong21.notion.site/JOIN-WING-e371a3ea53e44502b7f819a696f13189">https://jaehong21.notion.site/JOIN-WING-e371a3ea53e44502b7f819a696f13189</a><br>
소개 및 신청 링크 또한 WING 노션 소개페이지에 게시되어있습니다. 소개 페이지를 한 번 읽으신 이후에, 지원하시는 것을 추천드립니다.

<h3>🔥 문의 및 Q&A</h3>
관련 문의가 많은 경우에는 평가 요소 및 구체적인 선발 과정 등을 이야기하는 별도의 Q&A 세션을 진행하고자 합니다. <br>
더 궁금한 사항은 제 카톡이나 010-5513-2743 문자로 자유롭게 연락주시면 됩니다.''',
        deadline: DateTime.now().add(2.days),
        createdAt: DateTime.now(),
        imagesUrl: List.generate(
          maxPage,
          (_) =>
              'https://picsum.photos/seed/${Random().nextInt(100000)}/${Random().nextInt(500) + 100}/${Random().nextInt(500) + 100}',
        ),
      );
}
