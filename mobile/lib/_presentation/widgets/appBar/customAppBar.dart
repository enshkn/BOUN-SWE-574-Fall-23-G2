import 'package:flutter/material.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';

class CustomAppBar extends AppBar {
  CustomAppBar(
    BuildContext context, {
    super.key,
    super.automaticallyImplyLeading,
    String? title,
    super.actions,
    super.bottom,
  }) : super(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            title ?? '',
            style: const TextStyles.listTitle().copyWith(
              color: const Color(0xFF333333),
              fontSize: 16,
            ),
          ),
          iconTheme: IconThemeData(
            color: context.appBarColor,
            size: 20,
          ),
        );
}
