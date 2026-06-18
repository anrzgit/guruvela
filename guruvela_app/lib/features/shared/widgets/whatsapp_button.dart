import 'package:flutter/material.dart';

import '../../../core/constants/app_links.dart';
import '../../../core/utils/link_launcher.dart';

/// "Join WhatsApp Community" CTA, used on mentor cards, the mentors page and
/// preference guides. Always links to [AppLinks.whatsappCommunity].
class WhatsappButton extends StatelessWidget {
  const WhatsappButton({
    super.key,
    this.label = 'Join WhatsApp Community',
    this.expand = true,
  });

  final String label;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: () =>
          LinkLauncher.open(context, AppLinks.whatsappCommunity),
      icon: const Icon(Icons.chat_bubble_outline, size: 18),
      label: Text(label),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
