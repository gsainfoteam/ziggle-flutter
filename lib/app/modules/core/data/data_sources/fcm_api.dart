import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'fcm_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class FcmApi {
  @factoryMethod
  factory FcmApi(Dio dio) = _FcmApi;

  @POST('fcm')
  Future<void> fcm(@Field() String fcmToken);
}
