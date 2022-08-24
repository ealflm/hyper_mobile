import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hyper_customer/app/bindings/initial_binding.dart';
import 'package:hyper_customer/app/core/values/app_colors.dart';
import 'package:hyper_customer/app/core/widgets/scroll_behavior.dart';
import 'package:hyper_customer/app/network/dio_token_manager.dart';
import 'package:hyper_customer/app/routes/app_pages.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    String initialRoute = AppPages.INITIAL;
    if (TokenManager.instance.hasToken) {
      initialRoute = '${Routes.MAIN}?appInit=true';
    }

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Hyper",
          initialBinding: InitialBinding(),
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
          scrollBehavior: NoneScrollBehavior(),
          theme: ThemeData(
            colorScheme: const ColorScheme(
              primary: AppColors.primary400,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              background: AppColors.background,
              error: AppColors.error,
              onPrimary: AppColors.onPrimary,
              onSecondary: AppColors.onSecondary,
              onSurface: AppColors.onSurface,
              onBackground: AppColors.onBackground,
              onError: AppColors.onError,
              brightness: Brightness.light,
            ),
            focusColor: AppColors.orange,
          ),
        );
      },
    );
  }
}
