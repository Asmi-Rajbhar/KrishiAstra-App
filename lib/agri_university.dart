import 'package:krishiastra/app/core/bloc/language/language_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_event.dart';
import 'package:krishiastra/app/core/bloc/language/language_state.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/network/dio_client.dart';
import 'package:krishiastra/app/core/network/api_constants.dart';
import 'package:krishiastra/app/core/security/storage_service.dart';
import 'package:krishiastra/app/features/home/domain/repositories/i_home_repository.dart';
import 'package:krishiastra/app/features/home/data/repositories/home_repository.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_bloc.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/bloc/lifecycle_management_bloc.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/bloc/stage_bloc.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/bloc/video_gallery_bloc.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/scanner/scanner_bloc.dart';
import 'package:krishiastra/app/features/crop_variety/data/repositories/api_crop_repository.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/video_gallery/domain/repositories/i_video_repository.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_detail_bloc.dart';

import 'package:krishiastra/app/features/diagnostics/domain/repositories/i_diagnostic_repository.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/repositories/i_lifecycle_repository.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/features/success_stories/domain/repositories/i_success_story_repository.dart';
import 'package:krishiastra/app/features/crop_guide/domain/repositories/i_crop_guide_repository.dart';
import 'package:krishiastra/app/features/climatic_requirements/domain/repositories/i_climatic_repository.dart';
import 'package:krishiastra/app/features/climatic_requirements/data/repositories/climatic_repository.dart';
import 'package:krishiastra/app/features/climatic_requirements/presentation/bloc/climatic_bloc.dart';
import 'package:krishiastra/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:krishiastra/app/features/success_stories/presentation/bloc/success_stories_bloc.dart';
import 'package:krishiastra/app/features/diagnostics/data/repositories/api_diagnostic_repository.dart';
import 'package:krishiastra/app/features/lifecycle_management/data/repositories/api_lifecycle_repository.dart';
import 'package:krishiastra/app/features/success_stories/data/repositories/api_story_repository.dart';
import 'package:krishiastra/app/features/crop_guide/data/repositories/api_crop_guide_repository.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load();
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      // Global Flutter error handler
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (kReleaseMode) {
          // TODO: Send to crash reporter (e.g. Sentry, Firebase Crashlytics)
          debugPrint('Production Error: ${details.exception}');
        }
      };

      // Global ErrorWidget builder override for production
      ErrorWidget.builder = (FlutterErrorDetails details) {
        if (kDebugMode) {
          return ErrorWidget(details.exception);
        }
        return const _ProductionErrorWidget();
      };

      runApp(const AgriUniversityApp());
    },
    (error, stackTrace) {
      debugPrint('Uncaught Error: $error');
      debugPrint('Stacktrace: $stackTrace');
      // TODO: Send to crash reporter
    },
  );
}

class AgriUniversityApp extends StatefulWidget {
  const AgriUniversityApp({super.key});

  @override
  State<AgriUniversityApp> createState() => _AgriUniversityAppState();
}

class _AgriUniversityAppState extends State<AgriUniversityApp> {
  late final DioClient _dioClient;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _dioClient = DioClient();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await SharedPreferences.getInstance();

      // Store API token securely
      await SecureStorageService.saveToken(ApiConstants.apiToken);

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('Warning: Initialization failed: $e');
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [Provider<DioClient>.value(value: _dioClient)],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<IHomeRepository>(create: (_) => HomeRepository()),
          RepositoryProvider<ICropRepository>(
            create: (_) => ApiCropRepository(_dioClient.dio),
          ),
          RepositoryProvider<IDiagnosticRepository>(
            create: (_) => ApiDiagnosticRepository(_dioClient.dio),
          ),
          RepositoryProvider<IVideoRepository>(
            create: (context) =>
                RepositoryProvider.of<IDiagnosticRepository>(context)
                    as IVideoRepository,
          ),
          RepositoryProvider<ILifecycleRepository>(
            create: (context) => ApiLifecycleRepository(
              _dioClient.dio,
              RepositoryProvider.of<ICropRepository>(context),
            ),
          ),
          RepositoryProvider<ISuccessStoryRepository>(
            create: (_) => ApiStoryRepository(_dioClient.dio),
          ),
          RepositoryProvider<ICropGuideRepository>(
            create: (context) => ApiCropGuideRepository(
              _dioClient.dio,
              RepositoryProvider.of<IVideoRepository>(context),
            ),
          ),
          RepositoryProvider<IClimaticRepository>(
            create: (_) => ClimaticRepository(_dioClient.dio),
          ),
        ],
        child: MultiProvider(
          providers: [
            BlocProvider(
              create: (context) => LanguageBloc()..add(LoadLanguage()),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  CropProvider(RepositoryProvider.of<ICropRepository>(context))
                    ..loadData(),
            ),
            BlocProvider(
              create: (context) => HomeBloc(
                homeRepository: RepositoryProvider.of<IHomeRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => SuccessStoriesBloc(
                repository: RepositoryProvider.of<ISuccessStoryRepository>(
                  context,
                ),
              ),
            ),
            BlocProvider(
              create: (context) => CropVarietyBloc(
                cropVarietyRepository: RepositoryProvider.of<ICropRepository>(
                  context,
                ),
              ),
            ),
            BlocProvider(
              create: (context) => VideoGalleryBloc(
                videoRepository: RepositoryProvider.of<IVideoRepository>(
                  context,
                ),
              ),
            ),
            BlocProvider(
              create: (context) => CropVarietyDetailBloc(
                RepositoryProvider.of<ICropRepository>(context),
                RepositoryProvider.of<IVideoRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => DiagnosticBloc(
                diagnosticRepository:
                    RepositoryProvider.of<IDiagnosticRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => LifecycleManagementBloc(
                lifecycleRepository:
                    RepositoryProvider.of<ILifecycleRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => StageBloc(
                lifecycleRepository:
                    RepositoryProvider.of<ILifecycleRepository>(context),
              ),
            ),
            BlocProvider(
              create: (context) => ClimaticBloc(
                climaticRepository: RepositoryProvider.of<IClimaticRepository>(
                  context,
                ),
              ),
            ),
            BlocProvider(
              create: (context) => ScannerBloc(
                diagnosticRepository:
                    RepositoryProvider.of<IDiagnosticRepository>(context),
              ),
            ),
          ],
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return MaterialApp(
                locale: state.locale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('mr'),
                  Locale('hi'),
                  Locale('gu'),
                  Locale('kn'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                title: 'AgriUniversity',
                theme: appTheme,
                initialRoute: AppRouter.home,
                onGenerateRoute: AppRouter.onGenerateRoute,
                builder: (context, child) {
                  return child ?? const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProductionErrorWidget extends StatelessWidget {
  const _ProductionErrorWidget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriUniversity',
      theme: appTheme,
      home: const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 80),
                SizedBox(height: 24),
                Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  'We encountered an unexpected error. Please restart the application or try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
