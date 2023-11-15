import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/auth/data/data_sources/remote/authorize_interceptor.dart';

import 'locator.config.dart';

final sl = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  await sl.init();
  sl<Dio>().interceptors.add(sl<AuthorizeInterceptor>());
}
