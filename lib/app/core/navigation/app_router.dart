import 'package:krishiastra/app/features/climatic_requirements/presentation/screens/climatic_requirements_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/planting_season_page.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/screens/variety_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/diagnostic_details_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/diagnostics_center_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/nutrient_deficiency_page.dart';
import 'package:krishiastra/app/features/home/presentation/screens/home_page.dart';
import 'package:krishiastra/app/features/home/presentation/screens/crop_home_page.dart';
import 'package:krishiastra/app/features/home/presentation/screens/landing_page.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/screens/life_cycle_page.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/screens/stage_guidance_page.dart';
import 'package:krishiastra/app/features/success_stories/presentation/screens/success_stories_page.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/features/success_stories/presentation/screens/success_story_details_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/disease_list_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/disease_detail_page.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/screens/video_gallery_page.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/screens/environmental_stress_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/plant_scanner_page.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/screens/variety_detail_page.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/crop_lifecycle_stage.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/screens/video_details_page.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';

class AppRouter {
  static const String home = '/';
  static const String landing = '/landing';
  static const String cropHome = '/crop-home';
  static const String variety = '/variety';
  static const String diagnostics = '/diagnostics';
  static const String diagnosticDetail = '/diagnostic-detail';
  static const String nutrientDeficiency = '/nutrient-deficiency';
  static const String videoGallery = '/video-gallery';
  static const String lifecycle = '/lifecycle';
  static const String stageGuidance = '/stage-guidance';
  static const String successStories = '/success-stories';
  static const String successStoryDetail = '/success-story-detail';
  static const String climaticRequirements = '/climatic-requirements';
  static const String plantingSeason = '/planting-season';
  static const String diseaseList = '/disease-list';
  static const String environmentalStress = '/environmental-stress';
  static const String plantScanner = '/plant-scanner';
  static const String varietyDetail = '/variety-detail';
  static const String diseaseDetail = '/disease-detail';
  static const String videoDetail = '/video-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case videoDetail:
        final video = settings.arguments as Video;
        return MaterialPageRoute(
          builder: (_) => VideoDetailsPage(video: video),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case cropHome:
        String? cropName;
        int initialIndex = 0;
        if (settings.arguments is String) {
          cropName = settings.arguments as String;
        } else if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          cropName = args['cropName'] as String?;
          initialIndex = args['initialIndex'] as int? ?? 0;
        }
        return MaterialPageRoute(
          builder: (_) =>
              CropHomePage(cropName: cropName, initialIndex: initialIndex),
        );
      case variety:
        if (settings.arguments is CropInfo) {
          final cropInfo = settings.arguments as CropInfo;
          return MaterialPageRoute(
            builder: (_) => VarietyPage(cropInfo: cropInfo),
          );
        }
        return _errorRoute(settings.name);

      case varietyDetail:
        if (settings.arguments is CropVariety) {
          final variety = settings.arguments as CropVariety;
          return MaterialPageRoute(
            builder: (_) => VarietyDetailPage(variety: variety),
          );
        }
        return _errorRoute(settings.name);

      case diagnostics:
        return MaterialPageRoute(builder: (_) => const DiagnosticCenterPage());

      case diagnosticDetail:
        if (settings.arguments is Disease) {
          final disease = settings.arguments as Disease;
          return MaterialPageRoute(
            builder: (_) => DiagnosticDetailPage(disease: disease),
          );
        }
        return _errorRoute(settings.name);

      case nutrientDeficiency:
        return MaterialPageRoute(
          builder: (_) => const NutrientDeficiencyPage(),
        );

      case videoGallery:
        return MaterialPageRoute(builder: (_) => const VideoGalleryPage());

      case lifecycle:
        return MaterialPageRoute(builder: (_) => const CropLifecyclePage());

      case stageGuidance:
        if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          return MaterialPageRoute(
            builder: (_) => StageGuidancePage(
              stage: args['stage'] as CropLifecycleStage,
              stageNumber: args['stageNumber']?.toString() ?? '1',
            ),
          );
        }
        return _errorRoute(settings.name);

      case successStories:
        return MaterialPageRoute(builder: (_) => const SuccessStoriesPage());

      case successStoryDetail:
        if (settings.arguments is StoryDetail) {
          final story = settings.arguments as StoryDetail;
          return MaterialPageRoute(
            builder: (_) => StoryDetailPage(story: story),
          );
        }
        return _errorRoute(settings.name);

      case climaticRequirements:
        return MaterialPageRoute(
          builder: (_) => const ClimaticRequirementsPage(),
        );

      case plantingSeason:
        return MaterialPageRoute(
          builder: (_) => const PlantingSeasonGuidePage(),
        );
      case diseaseList:
        return MaterialPageRoute(builder: (_) => const DiseaseListPage());
      case environmentalStress:
        return MaterialPageRoute(
          builder: (_) => const EnvironmentalStressPage(),
        );
      case plantScanner:
        return MaterialPageRoute(builder: (_) => const PlantScannerPage());
      case diseaseDetail:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => DiseaseDetailPage(
              diseaseName: args['diseaseName'] as String,
              varietyId: args['varietyId'] as String?,
            ),
          );
        }
        return _errorRoute(settings.name);

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(
          child: Text(
            'No valid transition for route: $routeName\nCheck if arguments are correct.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
