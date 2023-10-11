import 'package:easy_localization/easy_localization.dart';
import 'package:swe/core/localization/locale_keys.g.dart';

import '../../_common/style/theme/theme_manager.dart';
import '../config/app_flavor_config.dart';
import '../main_common.dart';

Future<void> main() async {
  await mainCommon(
    AppFlavorConfig(
      flavor: AppFlavor.dev,
      title: LocaleKeys.appTitleDev.tr(),
      theme: ThemeManager.themeDev,
    ),
  );
}
