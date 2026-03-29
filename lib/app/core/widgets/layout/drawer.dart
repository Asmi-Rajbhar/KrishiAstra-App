import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_event.dart';
import 'package:krishiastra/app/core/bloc/language/language_state.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColors.backgroundLight,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accentGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.agriculture,
                    color: AppColors.white,
                    size: AppSizes.xl * 1.5,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.agriUniversity,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppSizes.fontHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildLanguageHeader(context),
                _buildLanguageItem(context, 'English', const Locale('en')),
                _buildLanguageItem(context, 'मराठी', const Locale('mr')),
                _buildLanguageItem(context, 'हिन्दी', const Locale('hi')),
                _buildLanguageItem(context, 'ગુજરાતી', const Locale('gu')),
                _buildLanguageItem(context, 'ಕನ್ನಡ', const Locale('kn')),
                const Divider(),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                color: AppColors.grey400,
                fontSize: AppSizes.fontCaption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        AppSizes.sm,
      ),
      child: Text(
        'Select Language',
        style: TextStyle(
          fontSize: AppSizes.fontCaption,
          fontWeight: FontWeight.bold,
          color: AppColors.grey600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageItem(BuildContext context, String title, Locale locale) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        final isSelected = state.locale.languageCode == locale.languageCode;

        return ListTile(
          leading: Icon(
            Icons.language,
            color: isSelected ? AppColors.accentGreen : AppColors.primaryColor,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.accentGreen
                  : AppColors.primaryColor,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
              : null,
          onTap: () {
            context.read<LanguageBloc>().add(ChangeLanguage(locale));
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
