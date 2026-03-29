import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart'; // Ensure you ran 'flutter gen-l10n'

// Import your pages
import 'splash_screen.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'screens/language_selection_screen.dart';
import 'providers/language_provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env"); 

  // Initialize Provider and load saved language
  LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.fetchLocale();

  runApp(
    ChangeNotifierProvider(
      create: (_) => languageProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Krishiastra',
          theme: ThemeData(primarySwatch: Colors.green),

          // Localization Setup
          locale: provider.appLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('mr'), // Marathi
            Locale('hi'), // Hindi
            Locale('gu'), // Gujarati
            Locale('kn'),
          ],

          // Logic:
          // If appLocale is null (first time user) -> Go to Language Selection
          // If appLocale is NOT null (returning user) -> Go to Splash Screen
          home:
              provider.appLocale == null
                  ? const LanguageSelectionScreen()
                  : SplashScreen(),

          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => RegisterPage(),
            '/splash': (context) => SplashScreen(),
          },
        );
      },
    );
  }
}
