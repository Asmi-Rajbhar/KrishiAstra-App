import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

class ChecklistCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isReminderActive;
  final ValueChanged<bool?> onToggleCompletion;
  final VoidCallback onToggleReminder;

  const ChecklistCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isReminderActive,
    required this.onToggleCompletion,
    required this.onToggleReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkbox with task details
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                // Checkbox
                SizedBox(
                  width: AppSizes.iconMd,
                  height: AppSizes.iconMd,
                  child: Checkbox(
                    value: isCompleted,
                    onChanged: onToggleCompletion,
                    shape: const CircleBorder(),
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.accentGreen;
                      }
                      return AppColors.white.withValues(alpha: 0.2);
                    }),
                    side: BorderSide.none,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: AppSizes.fontBody,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xxs),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.7),
                          fontSize: AppSizes.fontCaption,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.xs),
        // Reminder button
        Container(
          decoration: BoxDecoration(
            color: isReminderActive
                ? AppColors.white.withValues(alpha: 0.2)
                : AppColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: IconButton(
            icon: Icon(
              AppIcons.notifications,
              color: isReminderActive ? AppColors.lightYellow : AppColors.white,
            ),
            onPressed: onToggleReminder,
          ),
        ),
      ],
    );
  }
}
