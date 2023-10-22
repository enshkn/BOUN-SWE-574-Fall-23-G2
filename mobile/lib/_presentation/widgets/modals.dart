import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swe/_application/app/app_cubit.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_common/enums/bottom_tabs.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/app_button.dart';

Future<void> showLogoutModal(BuildContext context, ProfileCubit cubit) {
  return showModalBottomSheet<void>(
    context: context,
    shape: const ContinuousRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    builder: (context) {
      return SizedBox(
        height: 200,
        child: Column(
          children: [
            BaseWidgets.lowerGap,
            const Expanded(
              child: Center(
                child: Text(
                  'Logout',
                  style: TextStyles.title(),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Are you sure you want to logout?',
                  style: TextStyles.body(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: context.customWidthValue(0.4),
                    height: 50,
                    child: AppButton(
                      label: 'Cancel',
                      labelStyle: const TextStyles.button().copyWith(
                        color: Colors.black,
                      ),
                      border: Border.all(),
                      backgroundColor: Colors.transparent,
                      noIcon: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: context.customWidthValue(0.4),
                    height: 50,
                    child: AppButton(
                      label: 'Logout',
                      labelStyle: const TextStyles.button().copyWith(
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      noIcon: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      onPressed: () async {
                        final appCubit = context.read<AppCubit>();
                        await appCubit.changeBottomTab(BottomTabs.home);
                        await context.router.pushAndPopUntil(
                          const LoginRoute(),
                          predicate: (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
