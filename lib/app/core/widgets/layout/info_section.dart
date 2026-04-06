import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_sizes.dart';
import '../cards/section_card.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

/// InfoItem
///
/// A data model class representing an item within an `InfoSection`,
/// typically used to display a title, content, and an optional icon.
///
class InfoItem {
  final String? title;
  final String content;
  final IconData? icon;
  final Color? iconColor;

  const InfoItem({
    this.title,
    required this.content,
    this.icon,
    this.iconColor,
  });
}

enum InfoListStyle { simple, boxed }

/// InfoSection
///
/// A versatile section widget designed to display structured information.
/// It can render lists (simple or boxed) or tables of data within a `SectionCard`.
///
/// Used in:
/// - `variety_detail_page.dart`
/// - `diagnostic_details_page.dart`
/// - `stage_guidance_page.dart`
///
class InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? description;
  final Widget child;

  const InfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.description,
  });

  // Factory for List style
  static Widget list({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<InfoItem> items,
    String? description,
    InfoListStyle style = InfoListStyle.simple,
  }) {
    return InfoSection(
      title: title,
      icon: icon,
      description: description,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            style == InfoListStyle.simple
                ? _buildSimpleItem(items[i])
                : _buildBoxedItem(items[i]),
            if (i < items.length - 1) const SizedBox(height: AppSizes.md),
          ],
        ],
      ),
    );
  }

  // Factory for Table style
  static Widget table({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<String> headers,
    required List<List<String>> rows,
    required List<int> columnFlex,
  }) {
    return InfoSection(
      title: title,
      icon: icon,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            // Header Row
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
              decoration: const BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  topRight: Radius.circular(AppSizes.radiusMd),
                ),
                border: Border(bottom: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < headers.length; i++)
                    Expanded(
                      flex: columnFlex[i],
                      child: Text(
                        headers[i].toUpperCase(),
                        style: const TextStyle(
                          fontSize: AppSizes.fontCaption,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Data Rows
            for (int i = 0; i < rows.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.md,
                ),
                decoration: BoxDecoration(
                  border: i < rows.length - 1
                      ? const Border(
                          bottom: BorderSide(color: AppColors.grey200),
                        )
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int j = 0; j < rows[i].length; j++)
                      Expanded(
                        flex: columnFlex[j],
                        child: Text(
                          rows[i][j],
                          style: TextStyle(
                            fontSize: AppSizes.fontBody,
                            fontWeight: FontWeight.w500,
                            color: j == 0
                                ? AppColors.primaryColor
                                : AppColors.grey600,
                            height: 1.4,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      icon: Icon(icon, color: AppColors.primaryColor, size: AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null) ...[
            Text(
              description!,
              style: const TextStyle(
                fontSize: AppSizes.fontBody,
                color: AppColors.grey600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.md),
          ],
          child,
        ],
      ),
    );
  }

  static Widget _buildSimpleItem(InfoItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.xs),
          child: Icon(
            item.icon ?? AppIcons.circle,
            color: item.iconColor ?? AppColors.accentGreen,
            size: item.icon == null ? AppSizes.xs * 2 : AppSizes.iconMd,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title != null)
                Text(
                  item.title!,
                  style: const TextStyle(
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              Text(
                item.content,
                style: const TextStyle(
                  fontSize: AppSizes.fontBody,
                  height: 1.5,
                  color: AppColors.darkBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildBoxedItem(InfoItem item) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.icon ?? AppIcons.checkCircle,
            color: item.iconColor ?? AppColors.accentGreen,
            size: AppSizes.iconMd,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.title != null)
                  Text(
                    item.title!,
                    style: const TextStyle(
                      fontSize: AppSizes.fontBody,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                if (item.title != null) const SizedBox(height: AppSizes.xs),
                Text(
                  item.content,
                  style: const TextStyle(
                    fontSize: AppSizes.fontBody,
                    color: AppColors.grey600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
