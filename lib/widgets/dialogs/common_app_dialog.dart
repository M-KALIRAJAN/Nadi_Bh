import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class CommonAppDialog extends ConsumerWidget {
  final String title;
  final Widget content;
  final bool showCloseButton;
  final Color closeButtonColor;

  const CommonAppDialog({
    super.key,
    required this.title,
    required this.content,
    this.showCloseButton = true,
    this.closeButtonColor = Colors.red,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            Flexible(child: content),

            if (showCloseButton) ...[
              const SizedBox(height: 20),
              AppButton(
                text: "Close",
                height: 45,
                width: double.infinity,
                color: closeButtonColor,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
