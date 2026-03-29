import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'content_card.dart';

class SowingCalendarCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  const SowingCalendarCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      title: data?['title'] ?? 'Sowing Calendar',
      subtitle: data?['subtitle'] ?? 'Monthly suitability guide',
      icon: Icons.calendar_month,
      child: _buildMonthGrid(data?['suitableMonths'] as List<dynamic>?),
    );
  }

  Widget _buildMonthGrid(List<dynamic>? suitableIndices) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final List<int> suitableMonths = suitableIndices != null
        ? suitableIndices.map((e) => int.tryParse(e.toString()) ?? 0).toList()
        : [0, 1, 9, 10]; // Jan, Feb, Oct, Nov

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: AppSizes.sm,
        mainAxisSpacing: AppSizes.sm,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final isSuitable = suitableMonths.contains(index);
        return Container(
          decoration: BoxDecoration(
            color: isSuitable ? AppColors.primaryColor : AppColors.grey100,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            boxShadow: isSuitable
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.2),
                      blurRadius: AppSizes.xxs,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              months[index],
              style: TextStyle(
                color: isSuitable ? AppColors.white : AppColors.grey400,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
