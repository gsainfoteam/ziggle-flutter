import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_category.dart';
import 'package:ziggle/gen/strings.g.dart';

import 'author_model.dart';
import 'notice_content_model.dart';
import 'notice_reaction_model.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
class NoticeModel with _$NoticeModel implements NoticeEntity {
  const NoticeModel._();

  const factory NoticeModel({
    required int id,
    required int views,
    @Default([AppLocale.ko]) List<AppLocale> langs,
    DateTime? deadline,
    DateTime? currentDeadline,
    required DateTime createdAt,
    DateTime? deletedAt,
    @Default([]) List<String> tags,
    required String title,
    required String content,
    @Default([]) List<NoticeContentModel> additionalContents,
    required List<NoticeReactionModel> reactions,
    required AuthorModel author,
    @Default([]) List<String> imageUrls,
    @Default([]) List<String> documentUrls,
    @Default(false) bool isReminded,
    required NoticeCategory category,
    String? groupName,
    DateTime? publishedAt,
  }) = _NoticeModel;

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
  @override
  List<NetworkImage> get images =>
      imageUrls.map((e) => NetworkImage(e)).toList();
}
