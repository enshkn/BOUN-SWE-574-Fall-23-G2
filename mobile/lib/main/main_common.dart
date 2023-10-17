import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swe/_core/env/env.dart';

import '../_common/providers/app_providers.dart';
import '../_core/init/application_init.dart';
import '../_core/localization/localization_manager.dart';
import '../_presentation/_route/router.dart';
import 'config/app_flavor_config.dart';

final appRouter = AppRouter();

Future<void> mainCommon(AppFlavorConfig config) async {
  AppEnv.setConfig(config);
  await ApplicationInit.runZonedArea(
    EasyLocalization(
      supportedLocales: LocalizationManager.instance.supportedLocales,
      useOnlyLangCode: LocalizationManager.instance.useOnlyLangCode,
      path: LocalizationManager.instance.path,
      child: MyApp(config: config),
    ),
    config: config,
  );
}

class MyApp extends StatelessWidget {
  final AppFlavorConfig config;
  const MyApp({
    required this.config,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ...ApplicationProvider.providers,
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner:
            config.flavor == AppFlavor.dev ? true : false,
        title: config.title,
        theme: config.theme?.copyWith(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF071F05),
            unselectedItemColor: Color(0xFF071F05),
          ),
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routerConfig: appRouter.config(),
        builder: (context, widget) => Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => GestureDetector(
              onTap: () {
                final currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
