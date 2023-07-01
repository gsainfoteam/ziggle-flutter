import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/data/model/login_response.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'api.stg.ziggle.gistory.me')
abstract class ApiProvider {
  factory ApiProvider(Dio dio, {String baseUrl}) = _ApiProvider;
  static ApiProvider get to => Get.find();

  @GET('/user/login')
  Future<LoginResponse> login(@Query('auth_code') String authCode);
}
