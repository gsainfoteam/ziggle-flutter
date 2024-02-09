import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'locator.config.dart';

final sl = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  await sl.init(
    environmentFilter: const NoEnvOrContainsAny(
      kReleaseMode ? {Environment.prod} : {Environment.dev},
    ),
  );
}
