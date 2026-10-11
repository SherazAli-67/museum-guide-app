import 'package:flutter/material.dart';
import 'package:musuem_guide_app_ui/constants/string_const.dart';
import 'package:musuem_guide_app_ui/core/app_colors.dart';
import 'package:musuem_guide_app_ui/routing/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: StringConst.appTitle,
      theme: ThemeData(
        brightness: .light,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: StringConst.appFontFamily,
        colorScheme: ColorScheme.light(
          surface: AppColors.background,
          primary: AppColors.textPrimary,
          onPrimary: AppColors.white,
          secondary: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
      ),
      builder: (ctx, child) => child!,
      routerConfig: router,
    );
  }
}
