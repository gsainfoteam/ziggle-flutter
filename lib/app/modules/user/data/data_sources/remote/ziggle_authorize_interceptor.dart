import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/repositories/flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/modules/user/data/repositories/ziggle_flutter_secure_storage_token_repository.dart';

@singleton
class ZiggleAuthorizeInterceptor extends AuthorizeInterceptor {
  ZiggleAuthorizeInterceptor(
      @Named.from(ZiggleFlutterSecureStorageTokenRepository) super.repository);
}
