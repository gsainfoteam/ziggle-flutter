import 'package:retrofit/retrofit.dart';

abstract class BaseAuthApi {
  Future login(@Query('token') String token);
  Future info();
}
