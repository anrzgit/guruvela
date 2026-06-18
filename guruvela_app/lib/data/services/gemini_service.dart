import 'package:google_generative_ai/google_generative_ai.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/predictor_constants.dart';
import '../../core/i18n/app_language.dart';

/// Thin wrapper over the Gemini SDK. Ports `gemini.js`: model `gemini-2.5-flash`,
/// 200 max output tokens, a concise system prompt localized to the selected
/// language. Returns friendly fallbacks on error / when unconfigured.
class GeminiService {
  GeminiService() : _model = _buildModel();

  final GenerativeModel? _model;

  bool get isConfigured => _model != null;

  static GenerativeModel? _buildModel() {
    if (!AppConfig.isGeminiConfigured) return null;
    return GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: PredictorConstants.geminiMaxOutputTokens,
      ),
    );
  }

  /// Returns a concise generative answer in [language]. Mirrors the web prompt.
  Future<String> getGenerativeResponse(
    String prompt,
    AppLanguage language,
  ) async {
    final model = _model;
    if (model == null) {
      return "The chatbot's AI features are not configured. "
          'Please contact the administrator.';
    }
    try {
      final fullPrompt =
          'You are a helpful assistant for a college counseling website called '
          'Guruvela. Answer the following user query very concisely (in 1-2 '
          'short sentences) in ${language.geminiName}. Do not use Markdown. '
          'User query: "$prompt"';
      final result = await model.generateContent([Content.text(fullPrompt)]);
      final text = result.text?.trim();
      if (text == null || text.isEmpty) {
        return 'Sorry, I encountered an error while trying to get a response. '
            'Please try again later.';
      }
      return text;
    } catch (_) {
      return 'Sorry, I encountered an error while trying to get a response. '
          'Please try again later.';
    }
  }
}
