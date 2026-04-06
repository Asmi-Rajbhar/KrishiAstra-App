import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_event.dart';
import 'package:krishiastra/app/core/bloc/language/language_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/utils/app_images.dart';

/// CustomAppBar
///
/// A custom application bar widget used throughout the AgriBuddy app.
/// It features a leading icon, a title, and an action icon (typically an avatar).
/// It implements `PreferredSizeWidget` for proper integration with `Scaffold`.
///
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? leadingIcon;
  final String titleText;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    this.leadingIcon,
    required this.titleText,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white.withValues(alpha: 0.2),
      elevation: 0,
      leading: leadingIcon != null && leadingIcon != AppIcons.menu
          ? IconButton(
              icon: Icon(
                leadingIcon,
                color: AppColors.primaryColor,
                size: AppSizes.iconXl,
              ),
              onPressed: () {
                if (onLeadingPressed != null) {
                  onLeadingPressed!();
                  return;
                }
                if (leadingIcon == AppIcons.arrowBackIosNew) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    // Fallback to home if we are at root and user tries to go back
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
                  }
                }
              },
            )
          : null,
      title: Text(
        titleText,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontSize: AppSizes.fontHeading,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return PopupMenuButton<Locale>(
              icon: const Icon(Icons.language, color: AppColors.primaryColor),
              onSelected: (Locale locale) {
                context.read<LanguageBloc>().add(ChangeLanguage(locale));
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                const PopupMenuItem<Locale>(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('mr'),
                  child: Text('मराठी'),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('hi'),
                  child: Text('हिन्दी'),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('gu'),
                  child: Text('ગુજરાતી'),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('kn'),
                  child: Text('ಕನ್ನಡ'),
                ),
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.md),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
            backgroundImage: const AssetImage(AppImages.quantbitLogo),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
