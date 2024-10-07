import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/core/domain/enums/api_channel.dart';

@module
abstract class DioModule {
  @Named('ziggle')
  Dio get ziggleDio =>
      Dio(BaseOptions(baseUrl: ApiChannel.ziggleByMode().baseUrl));

  @Named('groups')
  Dio get groupsDio =>
      Dio(BaseOptions(baseUrl: ApiChannel.groupsBymode().baseUrl));
}
