import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

class L10nHelper {
  static String getLocalizedMessage(BuildContext context, String? message) {
    if (message == null) return '';
    if (!message.startsWith('l10n:')) return message;

    final l10n = AppLocalizations.of(context)!;
    final parts = message.substring(5).split('|');
    final key = parts[0];
    final args = parts.length > 1 ? parts.sublist(1) : [];

    switch (key) {
      case 'diseaseDetectedButNotFound':
        return l10n.diseaseDetectedButNotFound(args.isNotEmpty ? args[0] : 'Unknown');
      case 'aiModelTimeout':
        return l10n.aiModelTimeout;
      case 'varietyIdRequired':
        return l10n.varietyIdRequired;
      case 'diseaseDetailsNotFound':
        return l10n.diseaseDetailsNotFound;
      case 'nutrientDetailsNotFound':
        return l10n.nutrientDetailsNotFound;
      case 'detectionFailed':
        return l10n.detectionFailed;
      case 'unknownError':
        return l10n.unknownError;
      case 'somethingWentWrong':
        return l10n.somethingWentWrong;
      // Add more cases as needed
      default:
        return message.substring(5); // Fallback to key itself
    }
  }
}
