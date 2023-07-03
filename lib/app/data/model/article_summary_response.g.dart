// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ArticleSummaryResponse _$$_ArticleSummaryResponseFromJson(
        Map<String, dynamic> json) =>
    _$_ArticleSummaryResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['notExistKeyTemporary'] as String? ?? placeholderUserName,
      views: json['views'] as int,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      imagesUrl: (json['imagesUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => TagResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_ArticleSummaryResponseToJson(
        _$_ArticleSummaryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'notExistKeyTemporary': instance.author,
      'views': instance.views,
      'deadline': instance.deadline?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'imagesUrl': instance.imagesUrl,
      'tags': instance.tags,
    };
