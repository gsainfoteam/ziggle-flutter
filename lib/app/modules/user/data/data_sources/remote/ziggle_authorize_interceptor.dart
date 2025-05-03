import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/values/strings.dart';

@singleton
class ZiggleAuthorizeInterceptor extends AuthorizeInterceptor {
  final String identifier = "ZiggleInterceptor";

  ZiggleAuthorizeInterceptor(
    @Named.from(ZiggleFlutterSecureStorageTokenRepository) super.repository,
    super.oAuthApi,
  ) : super(clientId: Strings.ziggleIdpClientId);

  @override
  Dio getDio() {
    return sl<ZiggleDio>();
  }
}
