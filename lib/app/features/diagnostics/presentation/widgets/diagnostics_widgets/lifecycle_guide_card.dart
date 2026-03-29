import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/widgets/cards/action_card.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/screens/life_cycle_page.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

/// LifecycleGuideCard
///
/// A card widget designed to promote the "Crop Lifecycle Guide".
/// It features a prominent call to action to navigate to the `CropLifecyclePage`.
///
/// Used in:
/// - `diagnostics_center_page.dart`
///
class LifecycleGuideCard extends StatelessWidget {
  const LifecycleGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: ActionCard(
        title: 'Crop Lifecycle Guide',
        subtitle: 'Stage-wise guidance from planting to harvest',
        icon: AppIcons.autorenew,
        buttonText: 'Start Guided Journey',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CropLifecyclePage()),
          );
        },
      ),
    );
  }
}
