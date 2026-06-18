import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/merch_product.dart';
import '../../../data/static_data/merch_data.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/page_hero.dart';

/// Merchandise catalog — port of `MerchandisePage.jsx` (static products).
class MerchandiseScreen extends StatelessWidget {
  const MerchandiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merchandise')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PageHero(
            title: 'Official Merchandise',
            subtitle:
                'Exclusive apparel for the IIT Mandi community and aspirants.',
            icon: Icons.shopping_bag_outlined,
          ),
          _Section(
            title: 'For IIT Mandi Students',
            products: MerchData.iitMandiProducts,
          ),
          _Section(
            title: 'For Aspirants & Fans',
            products: MerchData.fanProducts,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.products});
  final String title;
  final List<MerchProduct> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 280,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 250,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => _ProductCard(product: products[i]),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final MerchProduct product;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.checkroom,
                size: 48,
                color: context.colors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            product.name,
            style: context.text.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            product.description,
            style: context.text.bodySmall
                ?.copyWith(color: context.colors.textMuted),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration form coming soon!'),
                  ),
                );
              },
              child: const Text('Register Interest'),
            ),
          ),
        ],
      ),
    );
  }
}
