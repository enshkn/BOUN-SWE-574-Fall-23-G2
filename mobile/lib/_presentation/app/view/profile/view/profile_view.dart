import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
import 'package:swe/_presentation/widgets/modals.dart';

@RoutePage()
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileCubit, ProfileState>(
      onCubitReady: (cubit) {
        cubit.setContext(context);
      },
      builder: (context, cubit, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.asset(
                'assets/images/2dutlukfinal.png',
                fit: BoxFit.contain,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: IconButton.outlined(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.router.push(const ProfileDetailsRoute());
                    },
                  ),
                ),
              ),
            ],
          ),
          body: BaseScrollView(
            children: [
              const Divider(),
              ButtonCard(
                onPressed: () {
                  context.router.push(const MyStoriesRoute());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.chrome_reader_mode),
                          ),
                          BaseWidgets.normalGap,
                          const Text(
                            'My Stories',
                            style: TextStyles.listTitle(),
                          ),
                        ],
                      ),
                      BaseWidgets.normalGap,
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ButtonCard(
                onPressed: () {
                  context.router.push(const LikedStoiresRoute());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.chrome_reader_mode),
                          ),
                          BaseWidgets.normalGap,
                          const Text(
                            'Liked Stories',
                            style: TextStyles.listTitle(),
                          ),
                        ],
                      ),
                      BaseWidgets.normalGap,
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ButtonCard(
                onPressed: () {
                  context.router.push(const SavedStoriesRoute());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.chrome_reader_mode),
                          ),
                          BaseWidgets.normalGap,
                          const Text(
                            'Stashed Stories',
                            style: TextStyles.listTitle(),
                          ),
                        ],
                      ),
                      BaseWidgets.normalGap,
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: AppButton(
                  label: 'Logout',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  centerLabel: true,
                  noIcon: true,
                  onPressed: () {
                    showLogoutModal(context, cubit.logout);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
