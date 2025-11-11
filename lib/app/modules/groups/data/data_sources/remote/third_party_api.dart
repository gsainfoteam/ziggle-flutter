import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/token_request_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/token_response_model.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/user_info_model.dart';

part 'third_party_api.g.dart';

@injectable
@RestApi(baseUrl: 'third-party/')
abstract class ThirdPartyApi {
  @factoryMethod
  factory ThirdPartyApi(GroupsDio dio) = _ThirdPartyApi;

  @GET('authorize')
  Future<String> authorize(
    @Query('client_id') String clientId,
    @Query('redirect_uri') String redirectUri,
  );

  @POST('token')
  Future<TokenResponseModel> token(@Body() TokenRequestModel request);

  @GET('userinfo')
  Future<UserInfoModel> userinfo();
}
