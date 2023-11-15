import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/enums/notice_mine.dart';
import '../../domain/enums/notice_sort.dart';
import '../models/notice_list_model.dart';
import '../models/notice_model.dart';

part 'notice_api.g.dart';

@injectable
@RestApi(baseUrl: 'notice/')
abstract class NoticeApi {
  @factoryMethod
  factory NoticeApi(Dio dio) = _NoticeApi;

  @GET('')
  Future<NoticeListModel> getNotices({
    @Query('offset') int? offset,
    @Query('limit') int? limit,
    @Query('search') String? search,
    @Query('tags[]') List<String>? tags,
    @Query('orderBy') NoticeSort? orderBy,
    @Query('my') NoticeMine? my,
  });

  @POST('')
  Future<NoticeModel> writeNotice({
    @Field('title') required String title,
    @Field('body') required String body,
    @Field('deadline') required DateTime? deadline,
    @Field('images') required List<String>? images,
    @Field('tags') required List<int>? tags,
  });

  @GET('{id}')
  Future<NoticeModel> getNotice(@Path() int id);

  @POST('{id}/reminder')
  Future setReminder(@Path() int id);

  @DELETE('{id}/reminder')
  Future cancelReminder(@Path() int id);
}
