import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart'; // Added import

/// VarietyCard
///
/// A specialized card widget designed to display key information about a
/// specific crop variety, including an image, name, yield, and maturity.
/// It supports hover effects for web/desktop and includes a button to
/// view full details.
///
/// Used in:
/// - `variety_page.dart`
///
class VarietyCard extends StatefulWidget {
  final CropVariety variety;
  final VoidCallback? onPressed;

  const VarietyCard({super.key, required this.variety, this.onPressed});

  @override
  State<VarietyCard> createState() => _VarietyCardState();
}

class _VarietyCardState extends State<VarietyCard> {
  bool _hovering = false;

  CropVariety get variety => widget.variety;
  VoidCallback? get onPressed => widget.onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovering = true);
      },
      onExit: (_) {
        setState(() => _hovering = false);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: AppSizes.sm,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: onPressed,
              splashColor: AppColors.primaryColor.withValues(alpha: 0.12),
              highlightColor: AppColors.primaryColor.withValues(alpha: 0.06),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                            color: AppColors.grey200,
                            image: DecorationImage(
                              image: NetworkImage(variety.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    variety.name,
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: AppSizes.fontTitle,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (variety.badgeText != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSizes.xs,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: variety.badgeColor,
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusMax,
                                        ),
                                      ),
                                      child: Text(
                                        variety.badgeText!,
                                        style: TextStyle(
                                          fontSize: AppSizes.fontCaption,
                                          fontWeight: FontWeight.bold,
                                          color: variety.badgeTextColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              _infoRow(
                                AppIcons.trendingUp,
                                "${AppLocalizations.of(context)!.yield} : ${variety.expectedYield ?? ''}",
                                AppColors.grey500,
                                AppColors.grey600,
                              ),
                              const SizedBox(height: AppSizes.xs),
                              _infoRow(
                                AppIcons.calendarToday,
                                "${AppLocalizations.of(context)!.maturity} : ${variety.maturity}",
                                AppColors.grey500,
                                AppColors.grey600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      0,
                      AppSizes.md,
                      AppSizes.md,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: _buildSimpleActionButton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String text,
    Color iconColor,
    Color textColor,
  ) => Row(
    children: [
      Icon(icon, size: AppSizes.iconSm, color: iconColor),
      const SizedBox(width: AppSizes.xs),
      Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontCaption,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _buttonContent(Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        AppLocalizations.of(context)!.seeFullDetailsButton,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
      const SizedBox(width: AppSizes.xs),
      Icon(AppIcons.chevronRight, color: color, size: AppSizes.iconMd),
    ],
  );

  Widget _buildSimpleActionButton() {
    final isPrimary = variety.isPrimaryAction;
    final active = _hovering;

    Color bgColor;
    Color txtColor;
    BoxDecoration decoration;

    if (isPrimary) {
      bgColor = active ? AppColors.white : AppColors.primaryColor;
      txtColor = active ? AppColors.primaryColor : AppColors.white;
      decoration = BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      );
    } else {
      bgColor = active ? AppColors.primaryColor : AppColors.transparent;
      txtColor = active ? AppColors.white : AppColors.primaryColor;
      decoration = BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      );
    }

    return Container(
      decoration: decoration,
      child: Center(child: _buttonContent(txtColor)),
    );
  }
}
