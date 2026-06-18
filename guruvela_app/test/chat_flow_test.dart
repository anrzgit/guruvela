import 'package:flutter_test/flutter_test.dart';
import 'package:guruvela_app/core/utils/chat_flow.dart';

/// Mirrors `web/tests/chatbotReset.test.js` and `chatbotGemini.test.js`.
void main() {
  group('ChatFlow — pending accumulation & reset', () {
    test('rank-only message asks for clarification, keeps pending rank', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      final r = bot.handle('My rank is 1000');
      expect(r.type, ChatFlowType.clarification);
      expect(bot.pendingRank, 1000);
    });

    test('general query after rank resets pending state', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      bot.handle('My rank is 1000');
      final r = bot.handle('Tell me about documents');
      expect(r.type, ChatFlowType.gemini);
      expect(bot.pendingRank, isNull);
      expect(bot.pendingCategory, isNull);
      expect(bot.pendingState, '');
      expect(bot.pendingExamType, 'JEE Main');
    });

    test('rank then category+state completes prediction and resets', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      bot.handle('My rank is 500');
      final r = bot.handle('What college can I get in Karnataka category SC?');
      expect(r.type, ChatFlowType.prediction);
      expect(r.params, isNotNull);
      expect(r.params!.rank, 500);
      expect(r.params!.category, 'SC');
      expect(r.params!.state, 'Karnataka');
      // Reset after a completed prediction.
      expect(bot.pendingRank, isNull);
      expect(bot.pendingCategory, isNull);
      expect(bot.pendingState, '');
      expect(bot.pendingExamType, 'JEE Main');
    });
  });

  group('ChatFlow — Gemini routing', () {
    test('general query routes to Gemini when configured', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      expect(bot.handle('hello world').type, ChatFlowType.gemini);
    });

    test('full rank query routes to prediction', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      expect(
        bot.handle('my rank is 1234 category general').type,
        ChatFlowType.prediction,
      );
    });

    test('incomplete rank query asks for clarification', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      expect(bot.handle('my rank is 1234').type, ChatFlowType.clarification);
    });

    test('follow-up completes prediction', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      bot.handle('my rank is 1234');
      expect(bot.handle('my category is obc').type, ChatFlowType.prediction);
    });

    test('general query falls back when Gemini not configured', () {
      final bot = ChatFlow(isGeminiConfigured: false);
      expect(bot.handle('hello world').type, ChatFlowType.fallback);
    });

    test('"good colleges?" general query still routes to Gemini', () {
      final bot = ChatFlow(isGeminiConfigured: true);
      expect(
        bot.handle('what are some good colleges?').type,
        ChatFlowType.gemini,
      );
    });

    test('tapped topic query routes to fixed response', () {
      final bot = ChatFlow(
        isGeminiConfigured: true,
        knownTopicQueries: {'What documents are needed for JoSAA?'},
      );
      expect(
        bot.handle('What documents are needed for JoSAA?').type,
        ChatFlowType.fixedResponse,
      );
    });
  });
}
