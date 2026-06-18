import '../../core/i18n/app_language.dart';
import '../models/chat_message.dart';

/// The four built-in topic chips shown under the chat greeting, with their
/// translated labels + example queries. Ported from `initialCategoriesBase`
/// and `uiTranslations` in `ChatInterface.jsx`.
abstract final class ChatTopicsData {
  ChatTopicsData._();

  static List<ChatTopic> forLanguage(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hinglish:
        return const [
          ChatTopic(
            id: 'cat_josaa_docs',
            topicId: 'josaa_documents_general',
            label: 'Zaroori Documents',
            exampleQuery: 'JoSAA ke liye documents?',
          ),
          ChatTopic(
            id: 'cat_seat_allotment',
            topicId: 'josaa_float_freeze_slide_meaning',
            label: 'Seat Allotment Process',
            exampleQuery: 'Float, Freeze, Slide kya hai?',
          ),
          ChatTopic(
            id: 'cat_prep_courses',
            topicId: 'iit_preparatory_what_is',
            label: 'IIT Prep Courses',
            exampleQuery: 'IIT preparatory rank kya hai?',
          ),
          ChatTopic(
            id: 'cat_colorblind',
            topicId: 'josaa_colorblind_general',
            label: 'Colorblindness Advice',
            exampleQuery: 'Colorblind medical certificate info',
          ),
        ];
      case AppLanguage.tenglish:
        return const [
          ChatTopic(
            id: 'cat_josaa_docs',
            topicId: 'josaa_documents_general',
            label: 'Kavalsina Documents',
            exampleQuery: 'JoSAA ki documents em kavali?',
          ),
          ChatTopic(
            id: 'cat_seat_allotment',
            topicId: 'josaa_float_freeze_slide_meaning',
            label: 'Seat Allotment Process',
            exampleQuery: 'Float, Freeze, Slide explain cheyandi?',
          ),
          ChatTopic(
            id: 'cat_prep_courses',
            topicId: 'iit_preparatory_what_is',
            label: 'IIT Prep Courses',
            exampleQuery: 'IIT preparatory rank ante enti?',
          ),
          ChatTopic(
            id: 'cat_colorblind',
            topicId: 'josaa_colorblind_general',
            label: 'Colorblindness Advice',
            exampleQuery: 'Colorblind medical certificate information',
          ),
        ];
      case AppLanguage.english:
        return const [
          ChatTopic(
            id: 'cat_josaa_docs',
            topicId: 'josaa_documents_general',
            label: 'Required Documents',
            exampleQuery: 'What documents are needed for JoSAA?',
          ),
          ChatTopic(
            id: 'cat_seat_allotment',
            topicId: 'josaa_float_freeze_slide_meaning',
            label: 'Seat Allotment Process',
            exampleQuery: 'Explain Float, Freeze, Slide',
          ),
          ChatTopic(
            id: 'cat_prep_courses',
            topicId: 'iit_preparatory_what_is',
            label: 'IIT Preparatory Courses',
            exampleQuery: 'What is IIT preparatory rank?',
          ),
          ChatTopic(
            id: 'cat_colorblind',
            topicId: 'josaa_colorblind_general',
            label: 'Colorblindness Advice',
            exampleQuery: 'Colorblind medical certificate query',
          ),
        ];
    }
  }
}
