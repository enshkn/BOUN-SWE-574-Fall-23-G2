import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/auth/model/follow_user_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';

import '../../../../../_domain/auth/model/user.dart';

@RoutePage()
class OtherProfileView extends StatefulWidget {
  final User profile;
  const OtherProfileView({required this.profile, super.key});

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView> {
  late ProfileCubit cubit;
  late final ExpansionTileController followerController;
  late final ExpansionTileController followingController;
  late final ExpansionTileController storyController;
  bool isfollowed = false;

  @override
  void initState() {
    // TODO: implement initState
    followerController = ExpansionTileController();
    followingController = ExpansionTileController();
    storyController = ExpansionTileController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<SessionCubit, SessionState>(
      context,
      builder: (context, sessionCubit, sessionState) {
        final user = sessionState.authUser;
        if (user!.following != null) {
          if (user.following!.contains(widget.profile)) {
            isfollowed = true;
          }
        }
        return BaseView<ProfileCubit, ProfileState>(
          onCubitReady: (cubit) async {
            this.cubit = cubit;
            cubit.setContext(context);
            await cubit.getOtherUser(widget.profile.id!);
          },
          builder: (context, cubit, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                context,
                title: 'View Profile',
              ),
              body: BaseLoader(
                isLoading: state.isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: BaseScrollView(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: state.otherProfile != null &&
                                state.otherProfile!.profilePhoto != null
                            ? CircleAvatar(
                                radius: 36,
                                backgroundImage: NetworkImage(
                                  state.otherProfile!.profilePhoto!,
                                ),
                              )
                            : const CircleAvatar(
                                radius: 36,
                                backgroundImage: AssetImage(
                                  'assets/images/profilePic.jpg',
                                ),
                              ),
                      ),
                      BaseWidgets.normalGap,
                      Row(
                        children: [
                          Text(
                            'Username: ',
                            style: const TextStyles.title().copyWith(),
                          ),
                          Text(
                            widget.profile.username!,
                            style: const TextStyles.body().copyWith(),
                          ),
                        ],
                      ),
                      BaseWidgets.lowerGap,
                      Row(
                        children: [
                          Text(
                            'Biography: ',
                            style: const TextStyles.title().copyWith(),
                          ),
                          Text(
                            widget.profile.biography != null
                                ? widget.profile.biography!
                                : '',
                            style: const TextStyles.body().copyWith(),
                          ),
                        ],
                      ),
                      BaseWidgets.lowerGap,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            controller: followerController,
                            title: const Text('Followers'),
                            children: [
                              if (state.otherProfile != null)
                                SizedBox(
                                  child: BaseListView<User>(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    items: state.otherProfile!.followers!,
                                    shrinkWrap: true,
                                    itemBuilder: (item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BaseWidgets.lowerGap,
                                            GestureDetector(
                                              onTap: () {
                                                context.router.push(
                                                  OtherProfileRoute(
                                                    profile: item,
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                state.otherProfile!.followers !=
                                                        null
                                                    ? item.username.toString()
                                                    : '',
                                                style: const TextStyles.body()
                                                    .copyWith(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      BaseWidgets.lowerGap,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            controller: followingController,
                            title: const Text('Following'),
                            children: [
                              if (state.otherProfile != null)
                                SizedBox(
                                  child: BaseListView<User>(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    items: state.otherProfile!.following!,
                                    shrinkWrap: true,
                                    itemBuilder: (item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BaseWidgets.lowerGap,
                                            GestureDetector(
                                              onTap: () {
                                                context.router.push(
                                                  OtherProfileRoute(
                                                    profile: item,
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                state.otherProfile!.following !=
                                                        null
                                                    ? item.username.toString()
                                                    : '',
                                                style: const TextStyles.body()
                                                    .copyWith(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      BaseWidgets.lowerGap,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            controller: storyController,
                            title: const Text('Stories'),
                            children: [
                              if (state.otherProfile != null)
                                SizedBox(
                                  child: BaseListView<StoryModel>(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    items: state.otherProfile!.stories!,
                                    shrinkWrap: true,
                                    itemBuilder: (item) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            BaseWidgets.lowerGap,
                                            GestureDetector(
                                              onTap: () {
                                                /*  context.router.push(
                                                  StoryDetailsRoute(
                                                    model: item,
                                                  ),
                                                ); */
                                              },
                                              child: Text(
                                                state.otherProfile!.stories !=
                                                        null
                                                    ? item.title
                                                    : '',
                                                style: const TextStyles.body()
                                                    .copyWith(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      BaseWidgets.lowerGap,
                      Padding(
                        padding: const EdgeInsets.fromLTRB(56, 8, 64, 8),
                        child: AppButton(
                          label: isfollowed ? 'Unfollow' : 'Follow',
                          noIcon: true,
                          backgroundColor:
                              isfollowed ? Colors.grey : context.appBarColor,
                          onPressed: () async {
                            final model = FollowUserModel(
                              userId: widget.profile.id!.toString(),
                            );
                            await cubit.followUser(model).then((value) {
                              if (value) {
                                setState(() {
                                  isfollowed = !isfollowed;
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
