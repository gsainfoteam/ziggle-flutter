import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/data/enums/notice_my.dart';
import 'package:ziggle/app/data/enums/notice_sort.dart';
import 'package:ziggle/app/data/model/article_list_response.dart';
import 'package:ziggle/app/data/model/article_request.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/login_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiProvider {
  factory ApiProvider(Dio dio, {String baseUrl}) = _ApiProvider;
  static ApiProvider get to => Get.find();

  @GET('/user/login')
  Future<LoginResponse> login(@Query('code') String authCode);

  @GET('/user/info')
  Future<UserInfoResponse> userInfo();

  @POST('/user/fcm')
  Future updateFcmToken(@Field('fcm_token') String fcmToken);

  @POST('/tag')
  Future<TagResponse> createTag(@Field() String name);

  @GET('/tag')
  Future<List<TagResponse>> getTags();

  @GET('/tag/one')
  Future<TagResponse> getTag(@Query('name') String name);

  @POST('/notice')
  Future<ArticleResponse> writeNotice(@Body() ArticleRequest article);

  @GET('/notice/all')
  Future<ArticleListResponse> getNotices({
    @Query('offset') int? offset,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('tags[]') List<String>? tags,
    @Query('orderBy') NoticeSort? orderBy,
    @Query('my') NoticeMy? my,
  });

  @GET('/notice/{id}')
  Future<ArticleResponse> getNotice(@Path() int id);

  @POST('/notice/{id}/reminder')
  Future setReminder(@Path() int id);

  @DELETE('/notice/{id}/reminder')
  Future cancelReminder(@Path() int id);

  @POST('/image/upload')
  @MultiPart()
  Future<List<String>> uploadImages(@Part(name: 'images') List<File> images);
}
