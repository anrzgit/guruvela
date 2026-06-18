import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../mentors/view_models/mentors_providers.dart';
import '../../mentors/widgets/mentor_card.dart';
import '../../shared/widgets/app_card.dart';
import '../widgets/home_hero.dart';

/// Landing page — port of `Landing.jsx`: hero, mission & vision, why-choose
/// cards, and a featured-mentors preview.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppConstants.appName,
              style: context.text.headlineMedium
                  ?.copyWith(color: context.scheme.primary),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: const [
          HomeHero(),
          _MissionVision(),
          _WhyChoose(),
          _FeaturedMentors(),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _MissionVision extends StatelessWidget {
  const _MissionVision();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Our Mission', style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'To democratize expert college consulting and make '
                  'high-quality JoSAA & CSAB guidance accessible to every '
                  'aspirant.',
                  style: context.text.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Our Vision', style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'A future where the stress around engineering admissions is '
                  'eliminated — replaced by data-driven clarity and authentic '
                  'mentorship.',
                  style: context.text.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyChoose extends StatelessWidget {
  const _WhyChoose();

  static const _items = [
    (Icons.insights, 'Data-Driven Predictor',
        'Historical counselling data powers accurate admission forecasts.'),
    (Icons.school, 'Ivy-League Expertise',
        'Mentors from top institutes who have navigated the process.'),
    (Icons.record_voice_over, 'Authentic Narratives',
        'Honest, first-hand guidance — no fluff, just what works.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why Choose Guruvela', style: context.text.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          for (final (icon, title, body) in _items) ...[
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(icon, color: context.scheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.text.titleMedium),
                        const SizedBox(height: 4),
                        Text(body, style: context.text.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _FeaturedMentors extends ConsumerWidget {
  const _FeaturedMentors();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredMentorsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Meet the Experts',
                    style: context.text.headlineMedium),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.mentors),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          featured.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => const SizedBox.shrink(),
            data: (list) => SizedBox(
              height: 270,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) => SizedBox(
                  width: 280,
                  child: MentorCard(mentor: list[i]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
