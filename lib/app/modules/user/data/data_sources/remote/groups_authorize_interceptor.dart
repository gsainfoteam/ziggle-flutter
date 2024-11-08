import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:ziggle/app/modules/user/data/repositories/groups_flutter_secure_storage_token_repository.dart';

@singleton
class GroupsAuthorizeInterceptor extends AuthorizeInterceptor {
  final String identifier = "GroupsInterceptor";

  GroupsAuthorizeInterceptor(
    @Named.from(GroupsFlutterSecureStorageTokenRepository) super.repository,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("Using $identifier");
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("Error in $identifier");
    super.onError(err, handler);
  }
}
