import 'package:flutter/material.dart';
import 'package:swe/_core/extensions/context_extensions.dart';

enum SuffixIconDirection { left, right, down, up }

class AppButton extends StatelessWidget {
  final Widget? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final String label;
  final bool centerLabel;
  final TextStyle? labelStyle;
  final VoidCallback? onPressed;
  final SuffixIconDirection suffixIconDirection;
  final Color? suffixIconColor;
  final bool noIcon;
  final bool inactive;
  const AppButton({
    required this.label,
    super.key,
    this.padding,
    this.onPressed,
    this.icon,
    this.labelStyle,
    this.centerLabel = false,
    this.backgroundColor,
    this.border,
    this.suffixIconDirection = SuffixIconDirection.right,
    this.suffixIconColor,
    this.noIcon = false,
    this.inactive = false,
  });

  AppButton.primary(
    BuildContext context, {
    required this.label,
    super.key,
    this.padding,
    this.onPressed,
    this.icon,
    this.centerLabel = false,
    this.border,
    this.suffixIconDirection = SuffixIconDirection.right,
    this.noIcon = false,
    this.inactive = false,
  })  : backgroundColor = context.appBarColor,
        labelStyle =
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        suffixIconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var bgColor = context.colors.background;
    late TextStyle style;

    if (backgroundColor != null) {
      bgColor = backgroundColor!;
    }

    if (inactive) {
      bgColor = context.colors.background;
      style =
          const TextStyle(color: Colors.black38, fontWeight: FontWeight.bold);
    } else if (labelStyle != null) {
      style = labelStyle!;
    } else {
      style = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    }

    return GestureDetector(
      onTap: inactive ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(12),
          color: bgColor,
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: noIcon
            ? Center(
                child: Text(
                  label,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (centerLabel) ...[
                    if (icon != null)
                      SizedBox(
                        width: 20,
                        child: icon,
                      )
                    else
                      const SizedBox(
                        width: 20,
                      ),
                    Text(
                      label,
                      style: labelStyle ??
                          const TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ] else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: icon,
                          ),
                        Text(
                          label,
                          style: labelStyle ??
                              const TextStyle(
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  SizedBox(
                    width: 20,
                    child: getSuffixIcon(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget getSuffixIcon() {
    final icon = Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: suffixIconColor,
    );

    switch (suffixIconDirection) {
      case SuffixIconDirection.left:
        return Transform.rotate(
          angle: 180 * 3.14 / 180,
          child: icon,
        );
      case SuffixIconDirection.right:
        return icon;
      case SuffixIconDirection.down:
        return Transform.rotate(
          angle: 90 * 3.14 / 180,
          child: icon,
        );
      case SuffixIconDirection.up:
        return Transform.rotate(
          angle: 270 * 3.14 / 180,
          child: icon,
        );
    }
  }
}
