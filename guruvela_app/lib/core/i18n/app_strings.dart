import 'app_language.dart';

/// Static UI strings, keyed by [AppLanguage]. Mirrors the web app's
/// `pageTranslations` objects and the chatbot greeting/topic strings.
///
/// Only strings that vary per-language or are reused live here; one-off labels
/// stay inline in their widgets to keep this from becoming a dumping ground.
class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  String _pick(Map<AppLanguage, String> map) =>
      map[language] ?? map[AppLanguage.english]!;

  // ---- Navigation / common ----
  String get navHome => _pick({
        AppLanguage.english: 'Home',
        AppLanguage.hinglish: 'Home',
        AppLanguage.tenglish: 'Home',
      });

  String get navPredictor => _pick({
        AppLanguage.english: 'Predictor',
        AppLanguage.hinglish: 'Predictor',
        AppLanguage.tenglish: 'Predictor',
      });

  String get navMentors => _pick({
        AppLanguage.english: 'Mentors',
        AppLanguage.hinglish: 'Mentors',
        AppLanguage.tenglish: 'Mentors',
      });

  String get navMore => _pick({
        AppLanguage.english: 'More',
        AppLanguage.hinglish: 'More',
        AppLanguage.tenglish: 'More',
      });

  // ---- Chatbot ----
  String get chatGreeting => _pick({
        AppLanguage.english:
            "Hi! I'm Guruvela's assistant. How can I help you with JoSAA/CSAB counseling today?",
        AppLanguage.hinglish:
            'Namaste! Main Guruvela ka assistant hoon. JoSAA/CSAB counselling mein aapki kya help kar sakta hoon?',
        AppLanguage.tenglish:
            'Namaste! Nenu Guruvela assistant. JoSAA/CSAB counselling lo ela help cheyagalanu?',
      });

  String get chatPlaceholder => _pick({
        AppLanguage.english: 'Type your question about JoSAA, CSAB, documents...',
        AppLanguage.hinglish: 'JoSAA, CSAB, documents ke baare mein poochiye...',
        AppLanguage.tenglish: 'JoSAA, CSAB, documents gurinchi adagandi...',
      });

  String get chatSend => _pick({
        AppLanguage.english: 'Send',
        AppLanguage.hinglish: 'Send',
        AppLanguage.tenglish: 'Send',
      });

  String get chatSending => _pick({
        AppLanguage.english: 'Sending...',
        AppLanguage.hinglish: 'Sending...',
        AppLanguage.tenglish: 'Sending...',
      });

  String get chatReset => _pick({
        AppLanguage.english: 'Reset Chat',
        AppLanguage.hinglish: 'Reset Chat',
        AppLanguage.tenglish: 'Reset Chat',
      });

  String get chatPickTopic => _pick({
        AppLanguage.english: 'Or, pick a common topic:',
        AppLanguage.hinglish: 'Ya, ek common topic chuniye:',
        AppLanguage.tenglish: 'Leda, common topic select cheyandi:',
      });

  String get chatAssistantTitle => 'Guruvela Assistant';

  String get chatViewFullList => _pick({
        AppLanguage.english: 'View Full List on Guruvela',
        AppLanguage.hinglish: 'Guruvela par poori list dekhiye',
        AppLanguage.tenglish: 'Guruvela lo full list chudandi',
      });

  String get chatTopColleges => _pick({
        AppLanguage.english:
            'Here are the top 3 colleges you might get based on your rank and category:',
        AppLanguage.hinglish:
            'Aapke rank aur category ke hisaab se yeh top 3 colleges mil sakte hain:',
        AppLanguage.tenglish:
            'Mee rank mariyu category prakaram ee top 3 colleges ravachu:',
      });

  String get chatNeedInfo => _pick({
        AppLanguage.english:
            'Can you tell me your JEE rank and category (General, OBC, SC, etc.)?',
        AppLanguage.hinglish:
            'Kya aap apna JEE rank aur category (General, OBC, SC, etc.) bata sakte hain?',
        AppLanguage.tenglish:
            'Mee JEE rank mariyu category (General, OBC, SC, etc.) cheppagalara?',
      });

  String get chatFallback => _pick({
        AppLanguage.english:
            "I'm sorry, I couldn't find a specific answer. Please try rephrasing, or check our guides for more information.",
        AppLanguage.hinglish:
            'Maaf kijiye, mujhe specific answer nahi mila. Kripya dobara try kijiye, ya guides dekhiye.',
        AppLanguage.tenglish:
            'Kshaminchandi, naaku specific answer dorakaledu. Malli try cheyandi, leda guides chudandi.',
      });

  String get chatError => _pick({
        AppLanguage.english:
            "Oops! I'm having a bit of trouble connecting to my knowledge base right now. Please try again in a moment.",
        AppLanguage.hinglish:
            'Oops! Abhi connect karne mein thodi dikkat aa rahi hai. Thodi der baad try kijiye.',
        AppLanguage.tenglish:
            'Oops! Ippudu connect cheyadam lo konchem ibbandi vasthondi. Konchem sepu tarvata try cheyandi.',
      });

  String get chatNotConfigured =>
      "The chatbot's AI features are not configured. Please contact the administrator.";
}
