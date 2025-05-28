import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/base_auth_api.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/user/data/models/user_model.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class UserApi extends BaseAuthApi {
  @factoryMethod
  factory UserApi(ZiggleDio dio) = _UserApi;

  @override
  @GET('info')
  Future<UserModel> info();
}
