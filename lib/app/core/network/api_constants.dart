import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  // Base URLs
  static String get baseUrl => dotenv.env['BASE_URL']!;

  static String get apiToken => dotenv.env['API_TOKEN']!;

  static String get aiModelBaseUrl => dotenv.env['AI_MODEL_BASE_URL']!;

  // API Endpoints
  static String get getVideoList => dotenv.env['GET_VIDEO_LIST']!;

  static String get getArticleList => dotenv.env['GET_ARTICLE_LIST']!;

  static String get getArticlesDetails => dotenv.env['GET_ARTICLE_DETAILS']!;

  static String get getDiseaseMaster => dotenv.env['GET_DISEASE_MASTER']!;

  static String get getDiseasesList => dotenv.env['GET_DISEASES_LIST']!;

  static String get getDiseaseDetails => dotenv.env['GET_DISEASE_DETAILS']!;

  static String get getPlantationSeason => dotenv.env['GET_PLANTATION_SEASON']!;

  static String get getNutrientList => dotenv.env['GET_NUTRIENT_LIST']!;

  static String get getNutrientDetailsMaster =>
      dotenv.env['GET_NUTRIENT_DETAILS_MASTER']!;

  static String get getEnvironmentalStress =>
      dotenv.env['GET_ENVIRONMENTAL_STRESS']!;

  static String get getCropVarietyDetails =>
      dotenv.env['GET_CROP_VARIETY_DETAILS']!;

  static String get getCropVarietyList => dotenv.env['GET_CROP_VARIETY_LIST']!;

  static String get getCropLifecycle => dotenv.env['GET_CROP_LIFECYCLE']!;

  static String get getClimaticRequirements =>
      dotenv.env['GET_CLIMATIC_REQUIREMENTS']!;

  static String get getNutrientDeficiencyDetails =>
      dotenv.env['GET_NUTRIENT_DEFICIENCY_DETAILS']!;

  static String get getNutrientDeficiencyList =>
      dotenv.env['GET_NUTRIENT_DEFICIENCY_LIST']!;

  static String get getPlantationMethod => dotenv.env['GET_PLANTATION_METHOD']!;

  static String get getCropSeasons => dotenv.env['GET_CROP_SEASONS']!;

  static String get getCropLifecycleStages =>
      dotenv.env['GET_CROP_LIFECYCLE_STAGES']!;

  static String get getCropDetails => dotenv.env['GET_CROP_DETAILS']!;

  static String get getCropBasicDetails =>
      dotenv.env['GET_CROP_BASIC_DETAILS']!;

  static String get getRiskAndCare => dotenv.env['GET_RISK_AND_CARE']!;

  static String get getCropRequirements => dotenv.env['GET_CROP_REQUIREMENTS']!;
}
