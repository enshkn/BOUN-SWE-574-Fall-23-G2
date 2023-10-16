import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';

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
      builder: (context, cubit, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'StoryTeller',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton.outlined(
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      cubit.getProfileInfo();
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
                  ///
                  ///
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
                onPressed: () {},
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
            ],
          ),
        );
      },
    );
  }
}
