import 'package:flutter/material.dart';

mixin UserInfoTextFormFieldMixin<T extends StatefulWidget> on State<T> {
  final formInfoKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();

    surnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  String get name => nameController.text;
  String get username => usernameController.text;
  String get surname => surnameController.text;
  String get email => emailController.text;
  String get phone => phoneController.text;
  String get password => passwordController.text;
  String get passwordConfirm => passwordConfirmController.text;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
}
