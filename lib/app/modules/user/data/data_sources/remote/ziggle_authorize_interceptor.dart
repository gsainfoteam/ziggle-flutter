import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_token_repository.dart';

@singleton
class ZiggleAuthorizeInterceptor extends AuthorizeInterceptor {
  ZiggleAuthorizeInterceptor(ZiggleTokenRepository super.repository);
}
