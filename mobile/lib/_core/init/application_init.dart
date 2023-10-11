import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:swe/_core/env/env.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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

  static Future<void> _initOneSignal(AppFlavor flavor) async {
    await OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
    await OneSignal.shared.setAppId(AppEnv.onesignalAppId);
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
      await _initOneSignal(config.flavor);

      runApp(
        widget,
      );
    }, (error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  }
}
