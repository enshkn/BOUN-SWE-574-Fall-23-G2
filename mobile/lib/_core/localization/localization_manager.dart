import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../_domain/network/app_network_manager.dart';
import '../utility/helper_functions.dart';

class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._init();
  static LocalizationManager get instance => _instance;

  LocalizationManager._init();

  List<Locale> supportedLocales = <Locale>[
    const Locale('en'),
    const Locale('tr'),
  ];

  bool useOnlyLangCode = true;
  String path = 'assets/i10n';

  Locale selectedLocale = const Locale('tr');

  void getCachedLocale(BuildContext context) {
    selectedLocale = context.locale;
    di<AppNetworkManager>().changeLangHeader(selectedLocale.languageCode);
  }

  void changeLocale(BuildContext context) {
    final currentLocale = context.locale;
    if (currentLocale == selectedLocale) return;

    selectedLocale = currentLocale;
    di<AppNetworkManager>().changeLangHeader(selectedLocale.languageCode);
  }
}
