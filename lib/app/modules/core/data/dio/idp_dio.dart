import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/values/strings.dart';

@singleton
class IdPDio extends DioForNative {
  IdPDio() : super(BaseOptions(baseUrl: Strings.idpApiBaseUrl));
}
