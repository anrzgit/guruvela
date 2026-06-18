import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens external URLs in the platform browser, surfacing a snackbar on
/// failure. Centralized so every screen launches links the same way.
abstract final class LinkLauncher {
  LinkLauncher._();

  static Future<void> open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await canLaunchUrl(uri);
    if (ok) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }
}
