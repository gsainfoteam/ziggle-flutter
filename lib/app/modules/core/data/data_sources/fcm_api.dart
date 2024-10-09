import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';

part 'fcm_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class FcmApi {
  @factoryMethod
  factory FcmApi(ZiggleDio dio) = _FcmApi;

  @POST('fcm')
  Future<void> fcm(@Field() String fcmToken);
}
