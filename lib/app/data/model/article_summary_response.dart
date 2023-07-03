import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

part 'article_summary_response.freezed.dart';
part 'article_summary_response.g.dart';

@freezed
class ArticleSummaryResponse with _$ArticleSummaryResponse {
  const factory ArticleSummaryResponse({
    required int id,
    required String title,
    required String author,
    required int views,
    required DateTime? deadline,
    required DateTime createdAt,
    required List<String>? imagesUrl,
    @Default([]) List<TagResponse> tags,
  }) = _ArticleSummaryResponse;

  factory ArticleSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleSummaryResponseFromJson(json);

  factory ArticleSummaryResponse.sample(int maxPage) => ArticleSummaryResponse(
        id: 1,
        title: '지붕이로 붕붕붕 모두 다 같이 떠나요',
        author: placeholderUserName,
        views: Random().nextInt(200),
        deadline: Random().nextBool() ? null : DateTime.now().add(6.days),
        createdAt: DateTime.now(),
        imagesUrl: [
          if (Random().nextDouble() < 0.9)
            'https://picsum.photos/${Random().nextInt(500) + 100}/${Random().nextInt(500) + 100}'
        ],
        tags: const [
          TagResponse(id: 0, name: '모집'),
          TagResponse(id: 0, name: '지붕이'),
          TagResponse(id: 0, name: '붕붕붕'),
        ],
      );
}
