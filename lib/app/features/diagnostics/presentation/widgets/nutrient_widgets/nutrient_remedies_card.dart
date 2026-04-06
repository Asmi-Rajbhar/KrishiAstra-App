import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class NutrientRemediesCard extends StatelessWidget {
  const NutrientRemediesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackShadow,
            blurRadius: AppSizes.sm,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Correction & Remedies',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppSizes.fontTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          _buildRemedyItem(
            'Recommended Fertilizer Dosage (NPK 150:60:60)',
            context,
          ),
          const SizedBox(height: AppSizes.md),
          _buildRemedyItem(
            'Micronutrient Spray Schedule (Zinc & Iron)',
            context,
          ),
          const SizedBox(height: AppSizes.md),
          _buildRemedyItem('Organic Compost Amendment (10 tons/ha)', context),
          const SizedBox(height: AppSizes.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Generate Treatment Plan',
                style: TextStyle(
                  fontSize: AppSizes.fontBody,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemedyItem(String text, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSizes.iconSm,
          height: AppSizes.iconSm,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.primaryColor,
            size: 12,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.grey600,
              fontSize: AppSizes.fontBody,
            ),
          ),
        ),
      ],
    );
  }
}
