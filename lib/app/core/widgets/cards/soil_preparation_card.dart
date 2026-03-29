import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'content_card.dart';

class SoilPreparationCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  const SoilPreparationCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final steps = data?['steps'] as List<dynamic>?;

    return ContentCard(
      title: data?['title'] ?? 'Soil Preparation',
      subtitle: data?['subtitle'] ?? 'Step-by-step techniques',
      icon: Icons.agriculture,
      child: Stack(
        children: [
          // Timeline line
          Positioned(
            left: 19,
            top: 32,
            bottom: 32,
            child: Container(width: 2, color: AppColors.grey100),
          ),
          Column(
            children: steps != null
                ? steps.map((s) {
                    final isLast = steps.last == s;
                    final map = s is Map ? s : const {};
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSizes.lg,
                      ),
                      child: _buildTimelineStep(
                        icon: _mapIcon(map['icon']?.toString() ?? ''),
                        title: map['title']?.toString() ?? '',
                        description: map['description']?.toString() ?? '',
                      ),
                    );
                  }).toList()
                : const [
                    TimelineStep(
                      icon: Icons.filter_hdr,
                      title: 'Deep Ploughing',
                      description:
                          'First ploughing should be 20-25cm deep with a mould board plough.',
                    ),
                    SizedBox(height: AppSizes.lg),
                    TimelineStep(
                      icon: Icons.grid_on,
                      title: 'Harrowing',
                      description:
                          'Cross harrowing to break clods and obtain fine tilth.',
                    ),
                    SizedBox(height: AppSizes.lg),
                    TimelineStep(
                      icon: Icons.water,
                      title: 'Ridges & Furrows',
                      description:
                          'Form ridges and furrows at required spacing intervals.',
                    ),
                  ],
          ),
        ],
      ),
    );
  }

  IconData _mapIcon(String icon) {
    switch (icon) {
      case 'filter_hdr':
        return Icons.filter_hdr;
      case 'grid_on':
        return Icons.grid_on;
      case 'water':
        return Icons.water;
      default:
        return Icons.help;
    }
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return TimelineStep(icon: icon, title: title, description: description);
  }
}

class TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const TimelineStep({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accentGreen,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGreen.withValues(alpha: 0.2),
                blurRadius: AppSizes.sm,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.white, size: AppSizes.iconSm),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSizes.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: AppSizes.fontBody,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
