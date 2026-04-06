import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';

class DeficiencyCard extends StatelessWidget {
  final String imageUrl;
  final String nutrient;
  final Color color;
  final String? symptom;

  const DeficiencyCard({
    super.key,
    required this.imageUrl,
    required this.nutrient,
    required this.color,
    this.symptom,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180, // Approximate fixed width for grid-like feel
      child: BaseCard(
        padding: EdgeInsets.zero,
        color: AppColors.white,
        borderRadius: AppSizes.radiusLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusLg),
                topRight: Radius.circular(AppSizes.radiusLg),
              ),
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 120, color: AppColors.grey300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                    ),
                    child: Text(
                      nutrient,
                      style: TextStyle(
                        color: color,
                        fontSize: AppSizes.fontCaption,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (symptom != null) ...[
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      symptom!,
                      style: const TextStyle(
                        color: AppColors.grey600,
                        fontSize: AppSizes.fontCaption,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
