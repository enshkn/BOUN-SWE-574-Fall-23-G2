import 'package:flutter/material.dart';

import '../../../_common/style/text_styles.dart';

enum ModalHeaderActionType { clear, completed }

class ModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;
  final VoidCallback? onCompleted;
  final VoidCallback? onClear;
  final ModalHeaderActionType actionType;
  const ModalHeader({
    required this.title,
    this.onCompleted,
    this.onClose,
    this.onClear,
    this.actionType = ModalHeaderActionType.completed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 50,
          child: IconButton(
            onPressed: () {
              if (onClose != null) {
                onClose!();
                return;
              }

              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ),
        Text(
          title,
          style: const TextStyles.title().copyWith(letterSpacing: 0.4),
        ),
        _buildAction(),
      ],
    );
  }

  Widget _buildAction() {
    switch (actionType) {
      case ModalHeaderActionType.clear:
        if (onClear == null) return const SizedBox(width: 50);

        return TextButton(
          onPressed: onClear,
          child: const Text(
            'Clear',
            style: TextStyles.button(),
          ),
        );
      case ModalHeaderActionType.completed:
        if (onCompleted == null) return const SizedBox(width: 50);

        return TextButton(
          onPressed: onCompleted,
          child: const Text(
            'Ok',
            style: TextStyles.button(),
          ),
        );
    }
  }
}
