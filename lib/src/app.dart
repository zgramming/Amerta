import 'utils/fonts.dart';
import 'utils/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'utils/colors.dart';

ThemeData _buildTheme(Brightness brightness) {
  final baseTheme = ThemeData();

  return baseTheme.copyWith(
    useMaterial3: true,
    primaryColor: primary,
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: primary,
    ),
    textTheme: latoTextTheme(baseTheme.textTheme),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(360, 640),
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Amerta',
          theme: _buildTheme(Brightness.light),
          color: primary,
          routerConfig: router,
        );
      },
      // child: const WelcomePage(),
    );
  }
}
