import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/auth/auth_cubit.dart';
import 'package:swe/_application/auth/auth_state.dart';
import 'package:swe/_common/mixins/user_info_controller_mixin.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
import 'package:swe/_presentation/widgets/textformfield/app_text_form_field.dart';

@RoutePage()
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with UserInfoTextFormFieldMixin {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthCubit, AuthState>(
      onCubitReady: (cubit) => cubit.setContext(context),
      builder: (context, cubit, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: context.appBarColor),
            elevation: 0,
            backgroundColor: Colors.grey.shade200,
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          'assets/images/dutluk_logo.png',
                        ),
                      ),
                    ),
                  ),
                ),
                BaseWidgets.normalGap,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BaseWidgets.lowerGap,
                        AppTextFormField(
                          controller: usernameController,
                          hintText: 'Enter your username',
                          isRequired: true,
                        ),
                        BaseWidgets.lowerGap,
                        AppTextFormField(
                          controller: emailController,
                          hintText: 'Enter your email',
                          isRequired: true,
                        ),
                        BaseWidgets.lowerGap,
                        AppTextFormField.password(
                          isVisibile: isVisible,
                          controller: passwordController,
                          hintText: 'Enter your password',
                          onVisibilityChanged: () {
                            isVisible = !isVisible;
                          },
                        ),
                        BaseWidgets.lowerGap,
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ButtonCard(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              cubit.register(
                                username: username,
                                email: email,
                                password: password,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.appBarColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Register',
                                    style: const TextStyles.body().copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
