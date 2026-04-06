import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

// Define the model here or in a separate file
class LanguageOption {
  final String name;
  final String subtitle;
  final Locale locale;

  LanguageOption({
    required this.name,
    required this.subtitle,
    required this.locale,
  });
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale _selectedLocale = const Locale('en'); // Default selection

  final List<LanguageOption> _languages = [
    LanguageOption(
      name: 'English',
      subtitle: 'Farming in your language',
      locale: const Locale('en'),
    ),
    LanguageOption(
      name: 'मराठी',
      subtitle: 'स्वतःच्या भाषेत शेती',
      locale: const Locale('mr'),
    ),
    LanguageOption(
      name: 'हिन्दी',
      subtitle: 'खेती आपकी भाषा में',
      locale: const Locale('hi'),
    ),
    LanguageOption(
      name: 'ગુજરાતી',
      subtitle: 'ખેતી તમારી ભાષામાં',
      locale: const Locale('gu'),
    ),
    LanguageOption(
      name: 'ಕನ್ನಡ',
      subtitle: 'ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿ ಕೃಷಿ', // "Agriculture in your language"
      locale: const Locale('kn'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Namaste!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E8449),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your KrishiAstra Language',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLocale == language.locale;
                    return GestureDetector(
                      onTap:
                          () =>
                              setState(() => _selectedLocale = language.locale),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFFE8EAF6)
                                  : Colors.white,
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade400,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    language.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    language.subtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                            if (!isSelected)
                              const Icon(
                                Icons.circle_outlined,
                                color: Colors.grey,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // 1. Save the Language
                    await Provider.of<LanguageProvider>(
                      context,
                      listen: false,
                    ).changeLanguage(_selectedLocale);

                    // 2. Navigate to Splash Screen
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E8449),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
