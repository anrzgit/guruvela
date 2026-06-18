import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/mentor.dart';
import '../../../providers/core_providers.dart';
import '../../shared/widgets/app_card.dart';
import '../../../core/utils/link_launcher.dart';

/// Card for a single mentor — port of `MentorCard.jsx`. Avatar (with DiceBear
/// fallback), name + LinkedIn, branch badge, state, and the WhatsApp CTA.
class MentorCard extends ConsumerWidget {
  const MentorCard({super.key, required this.mentor});
  final Mentor mentor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolveImage = ref.watch(mentorImageResolverProvider);
    final imageUrl = resolveImage(mentor.profileImagePath, mentor.name);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Avatar(url: imageUrl, name: mentor.name),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  maxLines: 2,
                  mentor.name,
                  style: context.text.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              if (mentor.linkedinUrl != null) ...[
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => LinkLauncher.open(context, mentor.linkedinUrl!),
                  child: const Icon(
                    Icons.business_center,
                    size: 18,
                    color: AppColors.linkedIn,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: context.scheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              mentor.branch,
              style: context.text.bodySmall?.copyWith(
                color: context.scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mentor.state,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.name});
  final String url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final ring = context.scheme.primary.withValues(alpha: 0.15);
    // DiceBear returns SVG which cached_network_image can't decode; show the
    // initials fallback for those (and any load error).
    final isSvg = url.contains('dicebear') || url.endsWith('.svg');

    Widget fallback() => CircleAvatar(
      radius: 44,
      backgroundColor: context.scheme.primary,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: ring, shape: BoxShape.circle),
      child: (url.isEmpty || isSvg)
          ? fallback()
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                placeholder: (context, url) => fallback(),
                errorWidget: (context, url, error) => fallback(),
              ),
            ),
    );
  }
}
