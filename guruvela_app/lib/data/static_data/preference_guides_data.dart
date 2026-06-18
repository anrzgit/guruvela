import '../../core/i18n/app_language.dart';

/// A preference-guide section card (title + description). Static content
/// ported from `PreferenceGuidesPage.jsx` with per-language strings.
class PreferenceGuide {
  const PreferenceGuide({required this.title, required this.description});
  final String title;
  final String description;
}

abstract final class PreferenceGuidesData {
  PreferenceGuidesData._();

  static List<PreferenceGuide> forLanguage(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hinglish:
        return const [
          PreferenceGuide(
            title: 'JEE Main Aadharit College Preference List',
            description:
                'NITs, IIITs aur GFTIs ke liye JEE Main rank ke aadhar par '
                'ek general preference order. Alag-alag rank ranges ke liye '
                'upyukt.',
          ),
          PreferenceGuide(
            title: 'JEE Advanced Aadharit College Preference List',
            description:
                'IITs ke liye JEE Advanced rank ke aadhar par ek general '
                'preference order.',
          ),
        ];
      case AppLanguage.tenglish:
        return const [
          PreferenceGuide(
            title: 'JEE Main Adharita College Preference List',
            description:
                'NITs, IIITs mariyu GFTIs koraku JEE Main rank adharanga oka '
                'general preference order. Vividha rank ranges koraku '
                'anuvaina.',
          ),
          PreferenceGuide(
            title: 'JEE Advanced Adharita College Preference List',
            description:
                'IITs koraku JEE Advanced rank adharanga oka general '
                'preference order.',
          ),
        ];
      case AppLanguage.english:
        return const [
          PreferenceGuide(
            title: 'JEE Main Based College Preference List',
            description:
                'A general preference order for NITs, IIITs, and GFTIs based '
                'on JEE Main ranks. Suitable for different rank ranges.',
          ),
          PreferenceGuide(
            title: 'JEE Advanced Based College Preference List',
            description:
                'A general preference order for IITs based on JEE Advanced '
                'ranks.',
          ),
        ];
    }
  }
}
