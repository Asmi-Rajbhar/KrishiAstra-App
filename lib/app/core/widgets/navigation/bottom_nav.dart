import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

/// BottomNav
///
/// A custom bottom navigation bar widget for the AgriBuddy app.
/// It allows navigation between main sections like Home, Videos, Community, and Profile.
///
/// Used in:
/// - `home_screen.dart`
/// - `diagnostics_center_page.dart`
/// - `variety_detail_page.dart`
/// - `diagnostic_details_page.dart`
/// - `video_gallery_page.dart`
/// - `stage_guidance_page.dart`
/// - `variety_page.dart`
/// - `life_cycle_page.dart`
///
class BottomNav extends StatelessWidget {
  final int activeIndex;

  const BottomNav({super.key, this.activeIndex = 0});

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSizes.iconMd,
            color: isActive ? AppColors.primaryColor : AppColors.grey400,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.fontCaption,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppColors.primaryColor : AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        border: const Border(top: BorderSide(color: AppColors.lightBlue)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: AppSizes.xs,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppSizes.navBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(
                icon: AppIcons.home,
                label: 'Home',
                isActive: activeIndex == 0,
                onTap: () {
                  final provider = context.read<CropProvider>();
                  if (provider.hasSelection) {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRouter.landing,
                        (route) => false,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.landing,
                      );
                    }
                  } else {
                    Navigator.pushReplacementNamed(context, AppRouter.home);
                  }
                },
              ),
              buildNavItem(
                icon: AppIcons.playCircleOutlined,
                label: 'Videos',
                isActive: activeIndex == 1,
                onTap: () {
                  if (activeIndex != 1) {
                    Navigator.pushNamed(context, AppRouter.videoGallery);
                  }
                },
              ),
              buildNavItem(
                icon: AppIcons.groups,
                label: 'Community',
                isActive: activeIndex == 2,
                onTap: () {
                  if (activeIndex != 2) {
                    Navigator.pushNamed(context, AppRouter.successStories);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
