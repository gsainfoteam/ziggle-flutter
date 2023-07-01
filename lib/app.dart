import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/binding.dart';

import 'app/routes/pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      initialBinding: initialBinding,
      getPages: AppPages.routes,
    );
  }
}
