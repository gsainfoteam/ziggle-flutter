import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../../domain/enums/notice_sort.dart';
import '../../enums/notice_my.dart';
import '../../models/create_additional_notice_model.dart';
import '../../models/create_foreign_notice_model.dart';
import '../../models/create_notice_model.dart';
import '../../models/notice_list_model.dart';
import '../../models/notice_model.dart';

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
    @Query('lang') AppLocale? lang,
    @Query('search') String? search,
    @Query('tags[]') List<String>? tags,
    @Query('orderBy') NoticeSort? orderBy,
    @Query('my') NoticeMy? my,
  });

  @POST('')
  Future<NoticeModel> createNotice(@Body() CreateNoticeModel model);

  @GET('{id}')
  Future<NoticeModel> getNotice(
    @Path('id') int id, {
    @Query('isViewed') bool isViewed = false,
  });

  @DELETE('{id}')
  Future<void> deleteNotice(@Path('id') int id);

  @POST('{id}/additional')
  Future<NoticeModel> addAdditionalContent(
    @Path('id') int id,
    @Body() CreateAdditionalNoticeModel model,
  );

  @POST('{id}/{contentId}/foreign')
  Future<NoticeModel> addForeign(
    @Path('id') int id,
    @Path('contentId') int contentId,
    @Body() CreateForeignNoticeModel model,
  );

  @POST('{id}/reaction')
  Future<NoticeModel> addReaction(
    @Path('id') int id,
    @Field('emoji') String emoji,
  );

  @DELETE('{id}/reaction')
  Future<NoticeModel> removeReaction(
    @Path('id') int id,
    @Field('emoji') String emoji,
  );

  @POST('{id}/reminder')
  Future<NoticeModel> addReminder(@Path('id') int id);

  @DELETE('{id}/reminder')
  Future<NoticeModel> removeReminder(@Path('id') int id);
}
