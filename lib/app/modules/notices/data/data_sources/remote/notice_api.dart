import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/data/models/create_additional_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/create_foreign_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/create_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/get_notices_query_model.dart';
import 'package:ziggle/app/modules/notices/data/models/modify_notice_model.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_list_model.dart';
import 'package:ziggle/app/modules/notices/data/models/notice_model.dart';

part 'notice_api.g.dart';

@injectable
@RestApi(baseUrl: 'notice/')
abstract class NoticeApi {
  @factoryMethod
  factory NoticeApi(Dio dio) = _NoticeApi;

  @GET('')
  Future<NoticeListModel> getNotices(@Queries() GetNoticesQueryModel query);

  @POST('')
  Future<NoticeModel> createNotice(@Body() CreateNoticeModel model);

  @GET('{id}')
  Future<NoticeModel> getNotice(
    @Path('id') int id, {
    @Query('lang') Language? lang,
    @Query('isViewed') bool isViewed = false,
  });

  @PATCH('{id}')
  Future<NoticeModel> modifyNotice(
    @Path('id') int id,
    @Body() ModifyNoticeModel model,
  );

  @DELETE('{id}')
  Future<void> deleteNotice(@Path('id') int id);

  @POST('{id}/alarm')
  Future<void> alarm(@Path('id') int id);

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
}
