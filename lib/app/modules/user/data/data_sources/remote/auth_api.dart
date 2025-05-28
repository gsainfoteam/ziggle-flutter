import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/base_auth_api.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_user_model.dart';

part 'auth_api.g.dart';

@injectable
@RestApi(baseUrl: 'auth/')
abstract class AuthApi extends BaseAuthApi {
  @factoryMethod
  factory AuthApi(GroupsDio dio) = _AuthApi;

  @override
  @GET('info')
  Future<GroupUserModel> info();
}
