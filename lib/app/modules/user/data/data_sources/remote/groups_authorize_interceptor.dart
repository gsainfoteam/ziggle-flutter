import 'package:dio/src/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/core/data/dio/groups_dio.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_flutter_secure_storage_token_repository.dart';

@singleton
class GroupsAuthorizeInterceptor extends AuthorizeInterceptor {
  final String identifier = "GroupsInterceptor";

  GroupsAuthorizeInterceptor(
    @Named.from(GroupsFlutterSecureStorageTokenRepository) super.repository,
  );

  @override
  Dio getDio() {
    return sl<GroupsDio>();
  }

  @override
  Future<bool> refresh() async {
    await repository.deleteToken();
    return false;
  }
}
