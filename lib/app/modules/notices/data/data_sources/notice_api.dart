import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/notices/data/models/rest_write_notice_model.dart';

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
  Future<NoticeModel> writeNotice(@Body() RestWriteNoticeModel body);

  @GET('{id}')
  Future<NoticeModel> getNotice(@Path() int id);

  @DELETE('{id}')
  Future<void> deleteNotice(@Path() int id);

  @POST('{id}/reminder')
  Future setReminder(@Path() int id);

  @DELETE('{id}/reminder')
  Future cancelReminder(@Path() int id);
}
