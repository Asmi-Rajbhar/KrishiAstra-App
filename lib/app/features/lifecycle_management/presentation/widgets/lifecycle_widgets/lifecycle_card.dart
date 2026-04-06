import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

import 'package:krishiastra/app/features/lifecycle_management/domain/entities/stage_status.dart';

class LifecycleStageCard extends StatelessWidget {
  final String stageNumber;
  final IconData icon;
  final String title;
  final String description;
  final StageStatus status;
  final bool isLast;
  final VoidCallback? onPressed;

  const LifecycleStageCard({
    super.key,
    required this.stageNumber,
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
    this.onPressed,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Timeline line
        if (!isLast)
          const Positioned(
            left: 28, // Center of the 56px icon circle
            top: 56,
            bottom: 0,
            child: CustomPaint(
              size: Size(2, double.infinity),
              painter: _DashedLinePainter(),
            ),
          ),
        // Content
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 56,
              height: 56,
              margin: const EdgeInsets.only(bottom: AppSizes.xl * 1.5),
              decoration: BoxDecoration(
                color: status == StageStatus.current ||
                        status == StageStatus.completed
                    ? AppColors.accentGreen
                    : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: status == StageStatus.current
                        ? AppColors.accentGreen.withValues(alpha: 0.2)
                        : AppColors.black.withValues(alpha: 0.1),
                    blurRadius: status == StageStatus.current
                        ? AppSizes.sm
                        : AppSizes.xs,
                    spreadRadius: status == StageStatus.current ? 2 : 0,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: status == StageStatus.current ||
                        status == StageStatus.completed
                    ? AppColors.white
                    : AppColors.grey400,
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            // Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: AppSizes.xl * 1.5,
                  top: 4,
                ),
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: status == StageStatus.upcoming
                      ? AppColors.white.withValues(alpha: 0.6)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: status == StageStatus.current
                        ? AppColors.accentGreen.withValues(alpha: 0.3)
                        : AppColors.grey100,
                    width: status == StageStatus.current ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: status == StageStatus.current
                          ? AppColors.accentGreen.withValues(alpha: 0.15)
                          : AppColors.black.withValues(alpha: 0.03),
                      blurRadius:
                          status == StageStatus.current ? AppSizes.sm : AppSizes.xs,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STAGE $stageNumber',
                          style: TextStyle(
                            color: status == StageStatus.current
                                ? AppColors.accentGreen
                                : AppColors.grey400,
                            fontSize: AppSizes.fontCaption,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        _buildStatusBadge(context),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      title,
                      style: TextStyle(
                        color: status == StageStatus.upcoming
                            ? AppColors.grey600
                            : AppColors.primaryColor,
                        fontSize: AppSizes.fontTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xxs),
                    Text(
                      description,
                      style: TextStyle(
                        color: status == StageStatus.upcoming
                            ? AppColors.grey400
                            : AppColors.grey600,
                        fontSize: AppSizes.fontBody,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppOutlinedButton(
                      label: 'View Details',
                      icon: AppIcons.chevronRight,
                      onPressed: status != StageStatus.upcoming ? onPressed : null,
                      backgroundColor: status == StageStatus.current
                          ? AppColors.accentGreen
                          : AppColors.transparent,
                      foregroundColor: _getButtonTextColor(),
                      borderColor: status == StageStatus.current
                          ? AppColors.transparent
                          : status == StageStatus.upcoming
                              ? AppColors.grey100
                              : AppColors.grey200,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getButtonTextColor() {
    if (status == StageStatus.current) return AppColors.white;
    if (status == StageStatus.completed) return AppColors.primaryColor;
    return AppColors.grey400;
  }

  Widget _buildStatusBadge(BuildContext context) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case StageStatus.completed:
        text = AppLocalizations.of(context)!.completed;
        bgColor = AppColors.grey100;
        textColor = AppColors.grey500;
        break;
      case StageStatus.current:
        text = AppLocalizations.of(context)!.currentStage;
        bgColor = AppColors.accentGreen;
        textColor = AppColors.white;
        break;
      case StageStatus.upcoming:
        text = AppLocalizations.of(context)!.upcoming;
        bgColor = AppColors.transparent;
        textColor = AppColors.grey400;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontCaption,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
