import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ziggle/app/modules/core/data/dio/ziggle_dio.dart';

part 'document_api.g.dart';

@injectable
@RestApi(baseUrl: 'document/')
abstract class DocumentApi {
  @factoryMethod
  factory DocumentApi(ZiggleDio dio) = _DocumentApi;

  @POST('upload')
  @MultiPart()
  Future<List<String>> uploadDocuments(
    @Part(name: 'images') List<File> documents,
  );
}
