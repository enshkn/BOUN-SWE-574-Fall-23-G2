import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/auth/model/profile_update_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/app_button.dart';
import 'package:swe/_presentation/widgets/textformfield/app_text_form_field.dart';

@RoutePage()
class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  TextEditingController bioController = TextEditingController();
  late ProfileCubit cubit;
  final FocusNode _focusNode = FocusNode();
  final picker = ImagePicker();

  File? _file;
  Future<XFile?> _getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = File(image!.path);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<SessionCubit, SessionState>(
      context,
      builder: (context, sessionCubit, sessionState) {
        final user = sessionState.authUser;
        if (user!.biography != null) {
          bioController.text = user.biography!;
        }
        return BaseView<ProfileCubit, ProfileState>(
          onCubitReady: (cubit) async {
            this.cubit = cubit;
            cubit.setContext(context);
          },
          builder: (context, cubit, state) {
            return Scaffold(
              appBar: CustomAppBar(
                context,
                title: 'My Profile Page',
              ),
              body: BaseScrollView(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BaseWidgets.normalGap,
                  Center(
                    child: SizedBox(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: user.profilePhoto != null
                                ? CircleAvatar(
                                    radius: 56,
                                    backgroundImage: NetworkImage(
                                      user.profilePhoto!,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 56,
                                    backgroundImage: AssetImage(
                                      'assets/images/profilePic.jpg',
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () async {
                                await _getImage();
                                if (_file != null) {
                                  await cubit.updateProfileImage(_file!);
                                }
                              },
                              icon: const Icon(Icons.edit, size: 32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BaseWidgets.normalGap,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: AppTextFormField(
                      hintText: 'Write your bio',
                      controller: bioController,
                      maxLines: 10,
                    ),
                  ),
                  BaseWidgets.normalGap,
                  SizedBox(
                    width: 200,
                    child: AppButton.primary(
                      context,
                      label: 'Save',
                      noIcon: true,
                      onPressed: () async {
                        _focusNode.unfocus();
                        final model =
                            ProfileUpdateModel(biography: bioController.text);
                        await cubit.updateProfile(model).then((value) {
                          if (value) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
