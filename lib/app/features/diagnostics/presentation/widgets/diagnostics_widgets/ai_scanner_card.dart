import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:flutter/material.dart';

/// AIScannerCard
///
/// A premium call-to-action card for the AI scanning feature.
/// It uses the `ActionCard` to maintain consistency with other tool cards.
class AIScannerCard extends StatelessWidget {
  const AIScannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: AppSizes.lg,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Icon Container
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              AppIcons.centerFocusStrong,
              color: AppColors.white,
              size: AppSizes.iconXl * 1.5,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          // Title
          Text(
            l10n.aiScannerTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.fontTitle,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          // Subtitle
          Text(
            l10n.aiScannerSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: AppSizes.fontCaption,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          // Pill shaped button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.plantScanner);
            },
            icon: const Icon(
              AppIcons.cameraAlt,
              color: AppColors.white,
              size: AppSizes.iconMd,
            ),
            label: Text(
              l10n.aiScannerButton,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppSizes.fontBody,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xl,
                vertical: AppSizes.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMax),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
