import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_flutter_secure_storage_token_repository.dart';
import 'package:ziggle/app/values/strings.dart';

@singleton
class GroupsAuthorizeInterceptor extends AuthorizeInterceptor {
  final String identifier = "GroupsInterceptor";

  GroupsAuthorizeInterceptor(
    @Named.from(GroupsFlutterSecureStorageTokenRepository) super.repository,
    super.oAuthApi,
  ) : super(clientId: Strings.groupsIdpClientId);

  @override
  Dio getDio() {
    return sl<GroupsDio>();
  }
}
