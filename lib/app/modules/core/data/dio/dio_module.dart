import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  @Named('ziggleDio')
  Dio get ziggleDio =>
      Dio(BaseOptions(baseUrl: 'https://api.ziggle.gistory.me'));

  @lazySingleton
  @Named('groupsDio')
  Dio get groupsDio =>
      Dio(BaseOptions(baseUrl: 'https://api.groups.gistory.me'));
}
