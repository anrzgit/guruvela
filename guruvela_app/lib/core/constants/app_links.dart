/// External URLs used across the app. Ported from the web app's hard-coded
/// links so there is a single place to update them.
abstract final class AppLinks {
  AppLinks._();

  static const String whatsappCommunity =
      'https://chat.whatsapp.com/K8ZQUXHpJBwKgeTjuP7qfE';

  static const String csabDocumentsDrive =
      'https://drive.google.com/file/d/1Ycew4aaCgDVYfyLI8-H7YtZ9ff4WiQNw/view?usp=sharing';

  static const String premiumGuidanceForm =
      'https://docs.google.com/forms/d/e/1FAIpQLSdh6syRNkLn8RzrUTf7rSBO8wXiIoxZ98SRLdm014_3lhv8AQ/viewform';

  /// DiceBear initials avatar fallback (matches the web app's seed/colors).
  static String dicebearAvatar(String name) =>
      'https://api.dicebear.com/7.x/initials/svg?seed=${Uri.encodeComponent(name)}&backgroundColor=0047AB&textColor=ffffff';

  /// Supabase storage bucket holding mentor profile pictures.
  static const String profilePicBucket = 'profilepic';
}
