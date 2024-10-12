import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_flutter_secure_storage_token_repository.dart';

@singleton
class GroupsAuthorizeInterceptor extends AuthorizeInterceptor {
  GroupsAuthorizeInterceptor(
      @Named.from(GroupsFlutterSecureStorageTokenRepository) super.repository);
}
