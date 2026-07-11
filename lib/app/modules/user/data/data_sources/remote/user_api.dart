import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/user/data/models/user_model.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class UserApi {
  @factoryMethod
  factory UserApi(ZiggleDio dio) = _UserApi;

  @GET('info')
  Future<UserModel> info();

  @POST('consent')
  Future<void> consent();

  @DELETE('')
  Future<void> withdraw();
}
