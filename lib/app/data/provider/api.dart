import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/core/values/strings.dart';
import 'package:ziggle/app/data/model/article_request.dart';
import 'package:ziggle/app/data/model/article_response.dart';
import 'package:ziggle/app/data/model/article_summary_response.dart';
import 'package:ziggle/app/data/model/login_response.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/app/data/model/user_info_response.dart';

part 'api.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class ApiProvider {
  factory ApiProvider(Dio dio, {String baseUrl}) = _ApiProvider;
  static ApiProvider get to => Get.find();

  @GET('/user/login')
  Future<LoginResponse> login(@Query('auth_code') String authCode);

  @GET('/user/info')
  Future<UserInfoResponse> userInfo(@Query('user_uuid') String userUuid);

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
  Future<List<ArticleSummaryResponse>> getNotices([
    @Query('offset') int? offset,
    @Query('limit') int? limit,
  ]);

  @GET('/notice/{id}')
  Future<ArticleResponse> getNotice(@Path() int id);

  @POST('/image/upload')
  @MultiPart()
  Future<List<String>> uploadImages(@Part(name: 'images') List<File> images);
}
