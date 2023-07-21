// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ArticleListResponse _$$_ArticleListResponseFromJson(
        Map<String, dynamic> json) =>
    _$_ArticleListResponse(
      list: (json['list'] as List<dynamic>)
          .map(
              (e) => ArticleSummaryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$$_ArticleListResponseToJson(
        _$_ArticleListResponse instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };
