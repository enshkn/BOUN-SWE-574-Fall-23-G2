import 'package:flutter/material.dart';

import '../../../_common/style/text_styles.dart';

class AppTextFormField extends TextFormField {
  AppTextFormField({
    super.key,
    super.controller,
    String? hintText,
    TextStyle? hintStyle,
    super.keyboardType,
    String? Function(String?)? validator,
    bool isRequired = false,
    super.obscureText,
    super.onChanged,
    super.maxLines,
    super.readOnly,
  }) : super(
          decoration: InputDecoration(
            isDense: true,
            fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade900),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText:
                hintText != null ? '$hintText${isRequired ? '*' : ''}' : null,
            hintStyle: hintStyle ??
                const TextStyles.body().copyWith(
                  color: readOnly ? Colors.grey.shade400 : Colors.black54,
                ),
          ),
          validator: validator ??
              (val) {
                final isEmail = keyboardType == TextInputType.emailAddress;
                final required = isEmail ? true : isRequired;

                final isEmpty = val == null || val.isEmpty;
                if (required && isEmpty) {
                  return 'Required Field';
                }

                return null;
              },
          style: const TextStyles.body(),
        );

  AppTextFormField.password({
    bool isVisibile = false,
    super.key,
    super.controller,
    String? hintText,
    TextStyle? hintStyle,
    super.keyboardType,
    super.onChanged,
    VoidCallback? onVisibilityChanged,
    Key? suffixIconKey,
  }) : super(
          obscureText: !isVisibile,
          decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade900),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: hintText != null ? '$hintText*' : null,
            hintStyle: hintStyle ?? const TextStyles.body(),
            suffixIcon: InkWell(
              key: suffixIconKey,
              onTap: () {
                onVisibilityChanged?.call();
              },
              child: Icon(isVisibile ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          style: const TextStyles.body(),
          validator: (value) {
            return null;
          },
        );
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Required field';
  }

  return null;
}
