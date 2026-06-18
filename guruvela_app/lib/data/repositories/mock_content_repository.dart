import '../../core/constants/app_links.dart';
import '../models/content_page.dart';
import '../models/document_item.dart';
import '../models/mentor.dart';
import 'content_repository.dart';

/// Offline CMS data so every content screen renders without Supabase.
class MockContentRepository implements ContentRepository {
  const MockContentRepository();

  static const _mentors = [
    Mentor(
      id: 'm1',
      name: 'Ananya Sharma',
      branch: 'Computer Science',
      state: 'Delhi',
      linkedinUrl: 'https://www.linkedin.com/',
    ),
    Mentor(
      id: 'm2',
      name: 'Rohan Verma',
      branch: 'Electrical Engineering',
      state: 'Maharashtra',
      linkedinUrl: 'https://www.linkedin.com/',
    ),
    Mentor(
      id: 'm3',
      name: 'Priya Nair',
      branch: 'Mechanical Engineering',
      state: 'Kerala',
      linkedinUrl: 'https://www.linkedin.com/',
    ),
    Mentor(
      id: 'm4',
      name: 'Karthik Reddy',
      branch: 'Electronics & Communication',
      state: 'Telangana',
    ),
    Mentor(
      id: 'm5',
      name: 'Sneha Gupta',
      branch: 'Information Technology',
      state: 'Uttar Pradesh',
      linkedinUrl: 'https://www.linkedin.com/',
    ),
    Mentor(
      id: 'm6',
      name: 'Arjun Singh',
      branch: 'Civil Engineering',
      state: 'Rajasthan',
    ),
    Mentor(
      id: 'm7',
      name: 'Meera Iyer',
      branch: 'Chemical Engineering',
      state: 'Tamil Nadu',
      linkedinUrl: 'https://www.linkedin.com/',
    ),
    Mentor(
      id: 'm8',
      name: 'Aditya Kulkarni',
      branch: 'Mathematics & Computing',
      state: 'Karnataka',
    ),
  ];

  @override
  Future<List<Mentor>> fetchMentors({int? limit}) async {
    await _latency();
    final list = List<Mentor>.from(_mentors);
    return limit != null ? list.take(limit).toList() : list;
  }

  @override
  Future<MarkdownContent?> fetchStaticPage(
    String identifier,
    String languageCode,
  ) async {
    await _latency();
    return const MarkdownContent(
      title: 'About Guruvela',
      servedLanguage: 'en',
      markdown: '''
## Our Mission

To democratize expert college consulting and make high-quality JoSAA & CSAB
guidance accessible to every aspirant, regardless of background.

## Our Vision

We envision a future where the stress and confusion around engineering
admissions is eliminated — replaced by **data-driven clarity** and
**authentic mentorship**.

Guruvela combines a historical-cutoff prediction engine with guidance from
mentors who have walked the same path.

- 📊 Data-driven rank predictor
- 🎓 Mentors from top institutes
- 💬 An assistant that answers your counselling questions
''',
    );
  }

  @override
  Future<MarkdownContent?> fetchHowToUse(String languageCode) async {
    await _latency();
    return const MarkdownContent(
      title: 'How to Use Guruvela',
      servedLanguage: 'en',
      markdown: '''
A comprehensive guide on making the most out of our rank prediction models and
mentorship services.

### 1. Rank Predictor

1. Open the **Predictor** tab.
2. Choose your exam type (JEE Main / JEE Advanced).
3. Enter your rank, category, gender and quota.
4. Tap **Generate Prediction** to see likely institutes with probabilities.

### 2. CSAB Predictor

Use the **CSAB** tab for Special Round predictions — it operates on JEE Main
ranks only.

### 3. Ask the Assistant

Tap the chat button to ask anything about documents, seat allotment, or to get
quick college suggestions by typing your rank and category.

### 4. Connect with Mentors

Browse mentors by branch and state, and join the WhatsApp community for group
guidance.
''',
    );
  }

  @override
  Future<List<ContentPageSummary>> fetchContentIndex(
    String languageCode,
  ) async {
    await _latency();
    return const [
      ContentPageSummary(
        title: 'JoSAA Comprehensive FAQ',
        slug: 'josaa-comprehensive-faq',
        pageType: 'faq',
      ),
      ContentPageSummary(
        title: 'Understanding Float, Freeze & Slide',
        slug: 'float-freeze-slide',
        pageType: 'guide',
      ),
      ContentPageSummary(
        title: 'Documents Required for JoSAA',
        slug: 'josaa-documents-required',
        pageType: 'faq',
      ),
      ContentPageSummary(
        title: 'IIT Preparatory Course Explained',
        slug: 'iit-preparatory-course',
        pageType: 'guide',
      ),
      ContentPageSummary(
        title: 'Colorblindness & Medical Certificates',
        slug: 'colorblindness-medical',
        pageType: 'faq',
      ),
    ];
  }

  @override
  Future<MarkdownContent?> fetchContentBySlug(
    String slug,
    String languageCode,
  ) async {
    await _latency();
    final index = await fetchContentIndex(languageCode);
    final match = index.where((p) => p.slug == slug).firstOrNull;
    final title = match?.title ?? 'Guide';
    return MarkdownContent(
      title: title,
      servedLanguage: 'en',
      markdown: '''
## $title

This is sample content shown because no Supabase backend is configured.

When connected to the live database, this page renders the full markdown
article for **$slug**, including step-by-step instructions, tables and links.

> Tip: Add your `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define` to
> load real content.
''',
    );
  }

  @override
  Future<List<DocumentItem>> fetchDocuments(String category) async {
    await _latency();
    return const [
      DocumentItem(
        id: 'd1',
        title: 'JoSAA Business Rules',
        description: 'Official seat allocation and business rules document.',
        link: 'https://josaa.nic.in/',
      ),
      DocumentItem(
        id: 'd2',
        title: 'List of Required Documents',
        description: 'Documents to carry for reporting and verification.',
        link: 'https://josaa.nic.in/',
      ),
      DocumentItem(
        id: 'd3',
        title: 'Seat Matrix',
        description: 'Institute-wise seat matrix for the current year.',
        link: 'https://josaa.nic.in/',
      ),
      DocumentItem(
        id: 'd4',
        title: 'Important Dates & Schedule',
        description: 'Round-wise counselling schedule and deadlines.',
        link: 'https://josaa.nic.in/',
      ),
    ];
  }

  Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 350));
}

/// Mock image resolver shared with widgets: always uses the DiceBear avatar.
String mockMentorImageUrl(Mentor mentor) => AppLinks.dicebearAvatar(mentor.name);
