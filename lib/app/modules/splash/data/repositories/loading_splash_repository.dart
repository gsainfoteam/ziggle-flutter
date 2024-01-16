import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/splash_repository.dart';

@Singleton(as: SplashRepository)
class LoadingSplashRepository implements SplashRepository {
  @override
  Future<void> init() async {}

  @override
  Future<void> remove() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }
}
