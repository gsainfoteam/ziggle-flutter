// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ArticleResponse _$$_ArticleResponseFromJson(Map<String, dynamic> json) =>
    _$_ArticleResponse(
      id: json['id'] as int,
      title: json['title'] as String,
      views: json['views'] as int,
      body: json['body'] as String,
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
      author: json['notExistKeyTemporary'] as String? ?? placeholderUserName,
    );

Map<String, dynamic> _$$_ArticleResponseToJson(_$_ArticleResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'views': instance.views,
      'body': instance.body,
      'deadline': instance.deadline?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'imagesUrl': instance.imagesUrl,
      'tags': instance.tags,
      'notExistKeyTemporary': instance.author,
    };
