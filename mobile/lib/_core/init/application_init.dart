import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../../_core/storage/shared_preferences/shared_preferences_helper.dart';
import '../../injection/get_it_container.dart';
import '../../main/config/app_flavor_config.dart';

class ApplicationInit {
  ApplicationInit._();

  static Future<void> init(AppFlavorConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    await Firebase.initializeApp();

    await SharedPreferencesHelper.init();
    GetItContainer.configureDependencies();
  }

  static Future<void> runZonedArea(
    Widget widget, {
    required AppFlavorConfig config,
  }) async {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };

    return runZonedGuarded<Future<void>>(() async {
      await init(config);

      runApp(
        widget,
      );
    }, (error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  }
}
