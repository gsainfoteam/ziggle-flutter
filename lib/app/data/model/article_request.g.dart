// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ArticleRequest _$$_ArticleRequestFromJson(Map<String, dynamic> json) =>
    _$_ArticleRequest(
      title: json['title'] as String,
      body: json['body'] as String,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int).toList(),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_ArticleRequestToJson(_$_ArticleRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'deadline': instance.deadline?.toIso8601String(),
      'tags': instance.tags,
      'images': instance.images,
    };
