import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
  ];

  /// The name of the application or university
  ///
  /// In en, this message translates to:
  /// **'AgriUniversity'**
  String get agriUniversity;

  /// No description provided for @sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get sugarcane;

  /// No description provided for @currentFocus.
  ///
  /// In en, this message translates to:
  /// **'Current Focus'**
  String get currentFocus;

  /// No description provided for @sugarcaneScientificName.
  ///
  /// In en, this message translates to:
  /// **'Saccharum officinarum L.'**
  String get sugarcaneScientificName;

  /// No description provided for @sugarcaneDescription.
  ///
  /// In en, this message translates to:
  /// **'A high-value perennial grass essential for sugar production and biofuels. Requires specific tropical humidity levels for optimal yield.'**
  String get sugarcaneDescription;

  /// No description provided for @cropDetails.
  ///
  /// In en, this message translates to:
  /// **'Crop Details'**
  String get cropDetails;

  /// No description provided for @varieties.
  ///
  /// In en, this message translates to:
  /// **'Varieties'**
  String get varieties;

  /// No description provided for @varitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Explore high-yielding and resilient crop varieties'**
  String get varitiesDesc;

  /// No description provided for @varitiesButton.
  ///
  /// In en, this message translates to:
  /// **' View Varieties'**
  String get varitiesButton;

  /// No description provided for @cropInformation.
  ///
  /// In en, this message translates to:
  /// **'Crop Information'**
  String get cropInformation;

  /// No description provided for @cropInformationDesc.
  ///
  /// In en, this message translates to:
  /// **'Detailed information about crop varieties and characteristics'**
  String get cropInformationDesc;

  /// No description provided for @cropInformationButton.
  ///
  /// In en, this message translates to:
  /// **' View Details'**
  String get cropInformationButton;

  /// No description provided for @cropLifecycle.
  ///
  /// In en, this message translates to:
  /// **'Crop Lifecycle Guide'**
  String get cropLifecycle;

  /// No description provided for @cropLifecycleDesc.
  ///
  /// In en, this message translates to:
  /// **'Stage-wise guidance from planting to harvest.'**
  String get cropLifecycleDesc;

  /// No description provided for @cropLifecycleButton.
  ///
  /// In en, this message translates to:
  /// **' Start Guided Journey '**
  String get cropLifecycleButton;

  /// No description provided for @aboutCrop.
  ///
  /// In en, this message translates to:
  /// **'About the Crop'**
  String get aboutCrop;

  /// No description provided for @aboutCropDesc.
  ///
  /// In en, this message translates to:
  /// **'Origins, economic impact, and botanical characteristics of Sugarcane'**
  String get aboutCropDesc;

  /// No description provided for @aboutCropButton.
  ///
  /// In en, this message translates to:
  /// **' Learn More '**
  String get aboutCropButton;

  /// No description provided for @climaticRequirements.
  ///
  /// In en, this message translates to:
  /// **'Climatic Requirements'**
  String get climaticRequirements;

  /// No description provided for @climaticRequirementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Temperature, rainfall, and humidity zones for successful cultivation.'**
  String get climaticRequirementsDesc;

  /// No description provided for @climaticRequirementsButton.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get climaticRequirementsButton;

  /// No description provided for @viewClimaticRequirements.
  ///
  /// In en, this message translates to:
  /// **'View Climatic Requirements'**
  String get viewClimaticRequirements;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @currentStage.
  ///
  /// In en, this message translates to:
  /// **'Current Stage'**
  String get currentStage;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @plantingSeason.
  ///
  /// In en, this message translates to:
  /// **'Planting Season'**
  String get plantingSeason;

  /// No description provided for @plantingSeasonDesc.
  ///
  /// In en, this message translates to:
  /// **'Sowing calendar and soil preparation techniques for maximum growth.'**
  String get plantingSeasonDesc;

  /// No description provided for @watchVideoButton.
  ///
  /// In en, this message translates to:
  /// **' Watch Video '**
  String get watchVideoButton;

  /// No description provided for @pestManagement.
  ///
  /// In en, this message translates to:
  /// **'Pest Management'**
  String get pestManagement;

  /// No description provided for @pestManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Identify and manage common borers and diseases efficiently'**
  String get pestManagementDesc;

  /// No description provided for @pestManagementButton.
  ///
  /// In en, this message translates to:
  /// **' Open Diagnosis Tool '**
  String get pestManagementButton;

  /// No description provided for @sugarcaneVarieties.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane Varieties'**
  String get sugarcaneVarieties;

  /// No description provided for @yield.
  ///
  /// In en, this message translates to:
  /// **'Yield '**
  String get yield;

  /// No description provided for @maturity.
  ///
  /// In en, this message translates to:
  /// **'Maturity '**
  String get maturity;

  /// No description provided for @seeFullDetailsButton.
  ///
  /// In en, this message translates to:
  /// **'See Full Details'**
  String get seeFullDetailsButton;

  /// No description provided for @highYieldingVariety.
  ///
  /// In en, this message translates to:
  /// **'High Yielding Variety'**
  String get highYieldingVariety;

  /// No description provided for @varietyCharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Variety Characteristics'**
  String get varietyCharacteristics;

  /// No description provided for @parantage.
  ///
  /// In en, this message translates to:
  /// **'Parentage'**
  String get parantage;

  /// No description provided for @maturityPeriod.
  ///
  /// In en, this message translates to:
  /// **'Maturity Period'**
  String get maturityPeriod;

  /// No description provided for @plantationMonths.
  ///
  /// In en, this message translates to:
  /// **'Plantation Months'**
  String get plantationMonths;

  /// No description provided for @plantationMethods.
  ///
  /// In en, this message translates to:
  /// **'Plantation Methods'**
  String get plantationMethods;

  /// No description provided for @fertilizerMicroNutrientsSchedule.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer & Micro Nutrients Schedule'**
  String get fertilizerMicroNutrientsSchedule;

  /// No description provided for @growthStage.
  ///
  /// In en, this message translates to:
  /// **'Growth Stage'**
  String get growthStage;

  /// No description provided for @doseStage.
  ///
  /// In en, this message translates to:
  /// **'Dose Stage'**
  String get doseStage;

  /// No description provided for @recommendedNutrients.
  ///
  /// In en, this message translates to:
  /// **'Recommended Nutrients (kg/ha)'**
  String get recommendedNutrients;

  /// No description provided for @weedManagement.
  ///
  /// In en, this message translates to:
  /// **'Weed Management'**
  String get weedManagement;

  /// No description provided for @weedManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Effective strategies for controlling weeds during different growth stages.'**
  String get weedManagementDesc;

  /// No description provided for @preEmergence.
  ///
  /// In en, this message translates to:
  /// **'Pre-Emergence'**
  String get preEmergence;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Expert Recommendation'**
  String get expertRecommendation;

  /// No description provided for @sugarcaneLifecycle.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane Lifecycle'**
  String get sugarcaneLifecycle;

  /// No description provided for @nurserysetSelection.
  ///
  /// In en, this message translates to:
  /// **'Nursery / Set Selection'**
  String get nurserysetSelection;

  /// No description provided for @nurserySetSelectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Selection of healthy, disease-free seed canes with 2-3 buds.'**
  String get nurserySetSelectionDesc;

  /// No description provided for @germinationPhase.
  ///
  /// In en, this message translates to:
  /// **'Germination Phase '**
  String get germinationPhase;

  /// No description provided for @germinationPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'0-60 days after planting. Focus on moisture and soil temperature.'**
  String get germinationPhaseDesc;

  /// No description provided for @tilleringPhase.
  ///
  /// In en, this message translates to:
  /// **'Tillering Phase '**
  String get tilleringPhase;

  /// No description provided for @tilleringPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'120-270 days. Rapid stalk elongation and leaf development.'**
  String get tilleringPhaseDesc;

  /// No description provided for @grandGrowthPhase.
  ///
  /// In en, this message translates to:
  /// **'Grand Growth Phase '**
  String get grandGrowthPhase;

  /// No description provided for @grandGrowthPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'20-270 days. Rapid stalk elongation and leaf development.'**
  String get grandGrowthPhaseDesc;

  /// No description provided for @maturityPhase.
  ///
  /// In en, this message translates to:
  /// **'Maturity Phase '**
  String get maturityPhase;

  /// No description provided for @maturityPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'70-360 days. Sugar accumulation in the stalks begins.'**
  String get maturityPhaseDesc;

  /// No description provided for @harvestingPhase.
  ///
  /// In en, this message translates to:
  /// **'Harvesting Phase '**
  String get harvestingPhase;

  /// No description provided for @harvestingPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Final stage. Cutting of stalks and rapid transport to factory.'**
  String get harvestingPhaseDesc;

  /// No description provided for @whatToDo.
  ///
  /// In en, this message translates to:
  /// **'What to Do'**
  String get whatToDo;

  /// No description provided for @whatToAvoid.
  ///
  /// In en, this message translates to:
  /// **'What to Avoid'**
  String get whatToAvoid;

  /// No description provided for @wtd1.
  ///
  /// In en, this message translates to:
  /// **'Maintain consistent soil moisture through light misting.'**
  String get wtd1;

  /// No description provided for @wtd2.
  ///
  /// In en, this message translates to:
  /// **'Keep soil temperature between 25°C - 30°C.'**
  String get wtd2;

  /// No description provided for @wtd3.
  ///
  /// In en, this message translates to:
  /// **'Monitor daily for the first signs of green sprouts.'**
  String get wtd3;

  /// No description provided for @wta1.
  ///
  /// In en, this message translates to:
  /// **'Do not over-water; stagnant water can cause seed rot.'**
  String get wta1;

  /// No description provided for @wta2.
  ///
  /// In en, this message translates to:
  /// **'Avoid using heavy fertilizers until the first leaves appear.'**
  String get wta2;

  /// No description provided for @timeBoundChecklist.
  ///
  /// In en, this message translates to:
  /// **'Time-Bound Checklist'**
  String get timeBoundChecklist;

  /// No description provided for @tbcl1.
  ///
  /// In en, this message translates to:
  /// **'Day 1-3: Hydration Check'**
  String get tbcl1;

  /// No description provided for @tbcl1Desc.
  ///
  /// In en, this message translates to:
  /// **'Check moisture levels 3x daily'**
  String get tbcl1Desc;

  /// No description provided for @tbcl2.
  ///
  /// In en, this message translates to:
  /// **'Day 4-5: Soil Aeration'**
  String get tbcl2;

  /// No description provided for @tbcl2Desc.
  ///
  /// In en, this message translates to:
  /// **'Gently loosen top soil layer.'**
  String get tbcl2Desc;

  /// No description provided for @tbcl3.
  ///
  /// In en, this message translates to:
  /// **'Day 6-10: Root Strength'**
  String get tbcl3;

  /// No description provided for @tbcl3Desc.
  ///
  /// In en, this message translates to:
  /// **'Identify and mark early bloomers'**
  String get tbcl3Desc;

  /// No description provided for @tbcl4.
  ///
  /// In en, this message translates to:
  /// **'Day 11-15: Apply first dose of fertilizer'**
  String get tbcl4;

  /// No description provided for @tbcl4Desc.
  ///
  /// In en, this message translates to:
  /// **'Use balanced NPK fertilizer'**
  String get tbcl4Desc;

  /// No description provided for @costbenefitSummary.
  ///
  /// In en, this message translates to:
  /// **'Cost & Benefit Summary'**
  String get costbenefitSummary;

  /// No description provided for @videosgallery.
  ///
  /// In en, this message translates to:
  /// **'Videos & Gallery'**
  String get videosgallery;

  /// No description provided for @successStories.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStories;

  /// No description provided for @successStory.
  ///
  /// In en, this message translates to:
  /// **'Success Story'**
  String get successStory;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @organic.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get organic;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @readfullStoryButton.
  ///
  /// In en, this message translates to:
  /// **' Read Full Story '**
  String get readfullStoryButton;

  /// No description provided for @cropVariety.
  ///
  /// In en, this message translates to:
  /// **'Crop Variety'**
  String get cropVariety;

  /// No description provided for @co86032.
  ///
  /// In en, this message translates to:
  /// **'Co 86032'**
  String get co86032;

  /// No description provided for @co86032Yield.
  ///
  /// In en, this message translates to:
  /// **'110-120 tons/ha'**
  String get co86032Yield;

  /// No description provided for @co86032Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-13 months'**
  String get co86032Maturity;

  /// No description provided for @co86032Details.
  ///
  /// In en, this message translates to:
  /// **'A high-yielding variety known for its disease resistance and adaptability to various soil types.'**
  String get co86032Details;

  /// No description provided for @co86032Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 62175 x Co 6304'**
  String get co86032Parentage;

  /// No description provided for @co86032Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get co86032Resistance;

  /// No description provided for @co86032soilType.
  ///
  /// In en, this message translates to:
  /// **'All types of soils.'**
  String get co86032soilType;

  /// No description provided for @co86032expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Ideal for regions with moderate rainfall and well-drained soils.'**
  String get co86032expertRecommendation;

  /// No description provided for @co0238.
  ///
  /// In en, this message translates to:
  /// **'Co 0238'**
  String get co0238;

  /// No description provided for @co0238Yield.
  ///
  /// In en, this message translates to:
  /// **'100-115 tons/ha'**
  String get co0238Yield;

  /// No description provided for @co0238Maturity.
  ///
  /// In en, this message translates to:
  /// **'10 months'**
  String get co0238Maturity;

  /// No description provided for @co0238Details.
  ///
  /// In en, this message translates to:
  /// **'A variety favored for its early maturity and high sugar content.'**
  String get co0238Details;

  /// No description provided for @co0238Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 8347 x Co 85019'**
  String get co0238Parentage;

  /// No description provided for @co0238Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to wilt and mosaic virus.'**
  String get co0238Resistance;

  /// No description provided for @co0238soilType.
  ///
  /// In en, this message translates to:
  /// **'Loamy and clayey soils.'**
  String get co0238soilType;

  /// No description provided for @co0238expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with high humidity and consistent rainfall.'**
  String get co0238expertRecommendation;

  /// No description provided for @co671.
  ///
  /// In en, this message translates to:
  /// **'Co 671'**
  String get co671;

  /// No description provided for @co671Yield.
  ///
  /// In en, this message translates to:
  /// **'90-105 tons/ha'**
  String get co671Yield;

  /// No description provided for @co671Maturity.
  ///
  /// In en, this message translates to:
  /// **'11-12 months'**
  String get co671Maturity;

  /// No description provided for @co671Details.
  ///
  /// In en, this message translates to:
  /// **'Known for its robust growth and high sucrose levels, making it a preferred choice for sugar production.'**
  String get co671Details;

  /// No description provided for @co671Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 419 x Co 421'**
  String get co671Parentage;

  /// No description provided for @co671Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to shoot borer and top shoot borer.'**
  String get co671Resistance;

  /// No description provided for @co671soilType.
  ///
  /// In en, this message translates to:
  /// **'Sandy loam and red soils.'**
  String get co671soilType;

  /// No description provided for @co671expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Thrives in regions with warm temperatures and moderate rainfall.'**
  String get co671expertRecommendation;

  /// No description provided for @co8021.
  ///
  /// In en, this message translates to:
  /// **'Co 8021'**
  String get co8021;

  /// No description provided for @co8021Yield.
  ///
  /// In en, this message translates to:
  /// **'95-110 tons/ha'**
  String get co8021Yield;

  /// No description provided for @co8021Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-14 months'**
  String get co8021Maturity;

  /// No description provided for @co8021Details.
  ///
  /// In en, this message translates to:
  /// **'A variety that combines high yield with excellent juice quality.'**
  String get co8021Details;

  /// No description provided for @co8021Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 775 x Co 86032'**
  String get co8021Parentage;

  /// No description provided for @co8021Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get co8021Resistance;

  /// No description provided for @co8021soilType.
  ///
  /// In en, this message translates to:
  /// **'Alluvial and laterite soils.'**
  String get co8021soilType;

  /// No description provided for @co8021expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Suitable for areas with good irrigation facilities and fertile soils.'**
  String get co8021expertRecommendation;

  /// No description provided for @co13007.
  ///
  /// In en, this message translates to:
  /// **'Co 13007'**
  String get co13007;

  /// No description provided for @co13007Yield.
  ///
  /// In en, this message translates to:
  /// **'100-120 tons/ha'**
  String get co13007Yield;

  /// No description provided for @co13007Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-13 months'**
  String get co13007Maturity;

  /// No description provided for @co13007Details.
  ///
  /// In en, this message translates to:
  /// **'A high-yielding variety known for its disease resistance and adaptability to various soil types.'**
  String get co13007Details;

  /// No description provided for @co13007Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 775 x Co 86032'**
  String get co13007Parentage;

  /// No description provided for @co13007Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get co13007Resistance;

  /// No description provided for @co13007soilType.
  ///
  /// In en, this message translates to:
  /// **'All types of soils.'**
  String get co13007soilType;

  /// No description provided for @co13007expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Ideal for regions with moderate rainfall and well-drained soils.'**
  String get co13007expertRecommendation;

  /// No description provided for @co15012.
  ///
  /// In en, this message translates to:
  /// **'Co 15012'**
  String get co15012;

  /// No description provided for @co15012Yield.
  ///
  /// In en, this message translates to:
  /// **'105-125 tons/ha'**
  String get co15012Yield;

  /// No description provided for @co15012Maturity.
  ///
  /// In en, this message translates to:
  /// **'11-12 months'**
  String get co15012Maturity;

  /// No description provided for @co15012Details.
  ///
  /// In en, this message translates to:
  /// **'A variety favored for its early maturity and high sugar content.'**
  String get co15012Details;

  /// No description provided for @co15012Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 0238 x Co 86032'**
  String get co15012Parentage;

  /// No description provided for @co15012Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to wilt and mosaic virus.'**
  String get co15012Resistance;

  /// No description provided for @co15012soilType.
  ///
  /// In en, this message translates to:
  /// **'Loamy and clayey soils.'**
  String get co15012soilType;

  /// No description provided for @co15012expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with high humidity and consistent rainfall.'**
  String get co15012expertRecommendation;

  /// No description provided for @co8005.
  ///
  /// In en, this message translates to:
  /// **'Co 8005'**
  String get co8005;

  /// No description provided for @co8005Yield.
  ///
  /// In en, this message translates to:
  /// **'95-110 tons/ha'**
  String get co8005Yield;

  /// No description provided for @co8005Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-13 months'**
  String get co8005Maturity;

  /// No description provided for @co8005Details.
  ///
  /// In en, this message translates to:
  /// **'Known for its robust growth and high sucrose levels, making it a preferred choice for sugar production.'**
  String get co8005Details;

  /// No description provided for @co8005Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 419 x Co 421'**
  String get co8005Parentage;

  /// No description provided for @co8005Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to shoot borer and top shoot borer.'**
  String get co8005Resistance;

  /// No description provided for @co8005soilType.
  ///
  /// In en, this message translates to:
  /// **'Sandy loam and red soils.'**
  String get co8005soilType;

  /// No description provided for @co8005expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Thrives in regions with warm temperatures and moderate rainfall.'**
  String get co8005expertRecommendation;

  /// No description provided for @co10001.
  ///
  /// In en, this message translates to:
  /// **'Co 10001'**
  String get co10001;

  /// No description provided for @co10001Yield.
  ///
  /// In en, this message translates to:
  /// **'100-120 tons/ha'**
  String get co10001Yield;

  /// No description provided for @co10001Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-14 months'**
  String get co10001Maturity;

  /// No description provided for @co10001Details.
  ///
  /// In en, this message translates to:
  /// **'A variety that combines high yield with excellent juice quality.'**
  String get co10001Details;

  /// No description provided for @co10001Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 775 x Co 86032'**
  String get co10001Parentage;

  /// No description provided for @co10001Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get co10001Resistance;

  /// No description provided for @co10001soilType.
  ///
  /// In en, this message translates to:
  /// **'Alluvial and laterite soils.'**
  String get co10001soilType;

  /// No description provided for @co10001expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with good irrigation facilities and fertile soils.'**
  String get co10001expertRecommendation;

  /// No description provided for @co92005.
  ///
  /// In en, this message translates to:
  /// **'Co 92005'**
  String get co92005;

  /// No description provided for @co92005Yield.
  ///
  /// In en, this message translates to:
  /// **'90-105 tons/ha'**
  String get co92005Yield;

  /// No description provided for @co92005Maturity.
  ///
  /// In en, this message translates to:
  /// **'11-12 months'**
  String get co92005Maturity;

  /// No description provided for @co92005Details.
  ///
  /// In en, this message translates to:
  /// **'A high-yielding variety known for its disease resistance and adaptability to various soil types.'**
  String get co92005Details;

  /// No description provided for @co92005Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 62175   x Co 6304'**
  String get co92005Parentage;

  /// No description provided for @co92005Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get co92005Resistance;

  /// No description provided for @co92005soilType.
  ///
  /// In en, this message translates to:
  /// **'All types of soils.'**
  String get co92005soilType;

  /// No description provided for @co92005expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Ideal for regions with varying climatic conditions.'**
  String get co92005expertRecommendation;

  /// No description provided for @co740.
  ///
  /// In en, this message translates to:
  /// **'Co 740'**
  String get co740;

  /// No description provided for @co740Yield.
  ///
  /// In en, this message translates to:
  /// **'110-125 tons/ha'**
  String get co740Yield;

  /// No description provided for @co740Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-13 months'**
  String get co740Maturity;

  /// No description provided for @co740Details.
  ///
  /// In en, this message translates to:
  /// **'A variety favored for its early maturity and high sugar content.'**
  String get co740Details;

  /// No description provided for @co740Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 8347 x Co 85019'**
  String get co740Parentage;

  /// No description provided for @co740Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to wilt and mosaic virus.'**
  String get co740Resistance;

  /// No description provided for @co740soilType.
  ///
  /// In en, this message translates to:
  /// **'Loamy and clayey soils.'**
  String get co740soilType;

  /// No description provided for @co740expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with high humidity and consistent rainfall.'**
  String get co740expertRecommendation;

  /// No description provided for @vsi434.
  ///
  /// In en, this message translates to:
  /// **'VSI 434'**
  String get vsi434;

  /// No description provided for @vsi434Yield.
  ///
  /// In en, this message translates to:
  /// **'105-125 tons/ha'**
  String get vsi434Yield;

  /// No description provided for @vsi434Maturity.
  ///
  /// In en, this message translates to:
  /// **'11-12 months'**
  String get vsi434Maturity;

  /// No description provided for @vsi434Details.
  ///
  /// In en, this message translates to:
  /// **'Known for its robust growth and high sucrose levels, making it a preferred choice for sugar production.'**
  String get vsi434Details;

  /// No description provided for @vsi434Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 419 x Co 421'**
  String get vsi434Parentage;

  /// No description provided for @vsi434Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to shoot borer and top shoot borer.'**
  String get vsi434Resistance;

  /// No description provided for @vsi434soilType.
  ///
  /// In en, this message translates to:
  /// **'Sandy loam and red soils.'**
  String get vsi434soilType;

  /// No description provided for @vsi434expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Thrives in regions with warm temperatures and moderate rainfall.'**
  String get vsi434expertRecommendation;

  /// No description provided for @co94012.
  ///
  /// In en, this message translates to:
  /// **'Co 94012'**
  String get co94012;

  /// No description provided for @co94012Yield.
  ///
  /// In en, this message translates to:
  /// **'100-120 tons/ha'**
  String get co94012Yield;

  /// No description provided for @co94012Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-14 months'**
  String get co94012Maturity;

  /// No description provided for @co94012Details.
  ///
  /// In en, this message translates to:
  /// **'A variety that combines high yield with excellent juice quality.'**
  String get co94012Details;

  /// No description provided for @co94012Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 775 x Co 86032'**
  String get co94012Parentage;

  /// No description provided for @co94012Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get co94012Resistance;

  /// No description provided for @co94012soilType.
  ///
  /// In en, this message translates to:
  /// **'Alluvial and laterite soils.'**
  String get co94012soilType;

  /// No description provided for @co94012expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with good irrigation facilities and fertile soils.'**
  String get co94012expertRecommendation;

  /// No description provided for @coc671.
  ///
  /// In en, this message translates to:
  /// **'CoC 671'**
  String get coc671;

  /// No description provided for @coc671Yield.
  ///
  /// In en, this message translates to:
  /// **'90-105 tons/ha'**
  String get coc671Yield;

  /// No description provided for @coc671Maturity.
  ///
  /// In en, this message translates to:
  /// **'11-12 months'**
  String get coc671Maturity;

  /// No description provided for @coc671Details.
  ///
  /// In en, this message translates to:
  /// **'A high-yielding variety known for its disease resistance and adaptability to various soil types.'**
  String get coc671Details;

  /// No description provided for @coc671Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 62175 x Co 6304'**
  String get coc671Parentage;

  /// No description provided for @coc671Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get coc671Resistance;

  /// No description provided for @coc671soilType.
  ///
  /// In en, this message translates to:
  /// **'All types of soils.'**
  String get coc671soilType;

  /// No description provided for @coc671expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with good drainage and moderate rainfall.'**
  String get coc671expertRecommendation;

  /// No description provided for @covsi3102.
  ///
  /// In en, this message translates to:
  /// **'Co VSI 3102'**
  String get covsi3102;

  /// No description provided for @covsi3102Yield.
  ///
  /// In en, this message translates to:
  /// **'100-120 tons/ha'**
  String get covsi3102Yield;

  /// No description provided for @covsi3102Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-13 months'**
  String get covsi3102Maturity;

  /// No description provided for @covsi3102Details.
  ///
  /// In en, this message translates to:
  /// **'A variety favored for its early maturity and high sugar content.'**
  String get covsi3102Details;

  /// No description provided for @covsi3102Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 8347 x Co 85019'**
  String get covsi3102Parentage;

  /// No description provided for @covsi3102Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to wilt and mosaic virus.'**
  String get covsi3102Resistance;

  /// No description provided for @covsi3102soilType.
  ///
  /// In en, this message translates to:
  /// **'Loamy and clayey soils.'**
  String get covsi3102soilType;

  /// No description provided for @covsi3102expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Ideal for regions with high humidity and consistent rainfall.'**
  String get covsi3102expertRecommendation;

  /// No description provided for @covsi9805.
  ///
  /// In en, this message translates to:
  /// **'Co VSI 9805'**
  String get covsi9805;

  /// No description provided for @covsi9805Yield.
  ///
  /// In en, this message translates to:
  /// **'95-110 tons/ha'**
  String get covsi9805Yield;

  /// No description provided for @covsi9805Maturity.
  ///
  /// In en, this message translates to:
  /// **'12-13 months'**
  String get covsi9805Maturity;

  /// No description provided for @covsi9805Details.
  ///
  /// In en, this message translates to:
  /// **'Known for its robust growth and high sucrose levels, making it a preferred choice for sugar production.'**
  String get covsi9805Details;

  /// No description provided for @covsi9805Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 419 x Co 421'**
  String get covsi9805Parentage;

  /// No description provided for @covsi9805Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to shoot borer and top shoot borer.'**
  String get covsi9805Resistance;

  /// No description provided for @covsi9805soilType.
  ///
  /// In en, this message translates to:
  /// **'Sandy loam and red soils.'**
  String get covsi9805soilType;

  /// No description provided for @covsi9805expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Thrives in regions with warm temperatures and moderate rainfall.'**
  String get covsi9805expertRecommendation;

  /// No description provided for @com265.
  ///
  /// In en, this message translates to:
  /// **'Co M265'**
  String get com265;

  /// No description provided for @com265Yield.
  ///
  /// In en, this message translates to:
  /// **'105-125 tons/ha'**
  String get com265Yield;

  /// No description provided for @com265Maturity.
  ///
  /// In en, this message translates to:
  /// **'11-12 months'**
  String get com265Maturity;

  /// No description provided for @com265Details.
  ///
  /// In en, this message translates to:
  /// **'A variety that combines high yield with excellent juice quality.'**
  String get com265Details;

  /// No description provided for @com265Parentage.
  ///
  /// In en, this message translates to:
  /// **'Co 775 x Co 86032'**
  String get com265Parentage;

  /// No description provided for @com265Resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistant to red rot and smut diseases.'**
  String get com265Resistance;

  /// No description provided for @com265soilType.
  ///
  /// In en, this message translates to:
  /// **'Alluvial and laterite soils.'**
  String get com265soilType;

  /// No description provided for @com265expertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Best suited for areas with good irrigation facilities and fertile soils.'**
  String get com265expertRecommendation;

  /// No description provided for @author1.
  ///
  /// In en, this message translates to:
  /// **'Ramesh Patel'**
  String get author1;

  /// No description provided for @location1.
  ///
  /// In en, this message translates to:
  /// **'Gujarat, India'**
  String get location1;

  /// No description provided for @headline1.
  ///
  /// In en, this message translates to:
  /// **'How Ramesh tripled his Sugarcane yield'**
  String get headline1;

  /// No description provided for @yieldIncrease1.
  ///
  /// In en, this message translates to:
  /// **'Yield Increase: 300% '**
  String get yieldIncrease1;

  /// No description provided for @costSaved1.
  ///
  /// In en, this message translates to:
  /// **'Cost Saved: 25% '**
  String get costSaved1;

  /// No description provided for @contentParagraph1.
  ///
  /// In en, this message translates to:
  /// **'Discover the innovative fertilization techniques that transformed Ramesh\'s farm into a high-yield success in record time. By adopting a new set of bio-fertilizers and precision irrigation, Ramesh was able to reduce water consumption by 30% while boosting crop health.'**
  String get contentParagraph1;

  /// No description provided for @highlightText1.
  ///
  /// In en, this message translates to:
  /// **'The combination of soil testing and targeted nutrient application was the game-changer for my farm.'**
  String get highlightText1;

  /// No description provided for @author2.
  ///
  /// In en, this message translates to:
  /// **'Sunita Sharma'**
  String get author2;

  /// No description provided for @location2.
  ///
  /// In en, this message translates to:
  /// **'Maharashtra, India'**
  String get location2;

  /// No description provided for @headline2.
  ///
  /// In en, this message translates to:
  /// **'Sunita\'s Organic Revolution'**
  String get headline2;

  /// No description provided for @yieldIncrease2.
  ///
  /// In en, this message translates to:
  /// **'Yield Increase: 50%'**
  String get yieldIncrease2;

  /// No description provided for @costSaved2.
  ///
  /// In en, this message translates to:
  /// **'Cost Saved: 20,000'**
  String get costSaved2;

  /// No description provided for @contentParagraph2.
  ///
  /// In en, this message translates to:
  /// **'After years of chemical farming, Sunita switched to organic compost and saw her soil health improve drastically. Her story is a testament to the power of sustainable farming practices in building long-term soil fertility and reducing dependency on chemical inputs.'**
  String get contentParagraph2;

  /// No description provided for @highlightText2.
  ///
  /// In en, this message translates to:
  /// **'Going organic was the best decision I ever made. My soil is alive again, and my crops are healthier than ever.'**
  String get highlightText2;

  /// No description provided for @author3.
  ///
  /// In en, this message translates to:
  /// **'Anil Kumar'**
  String get author3;

  /// No description provided for @location3.
  ///
  /// In en, this message translates to:
  /// **'Punjab, India'**
  String get location3;

  /// No description provided for @headline3.
  ///
  /// In en, this message translates to:
  /// **'Smart Irrigation with Anil'**
  String get headline3;

  /// No description provided for @yieldIncrease3.
  ///
  /// In en, this message translates to:
  /// **'Yield Increase: 40%'**
  String get yieldIncrease3;

  /// No description provided for @costSaved3.
  ///
  /// In en, this message translates to:
  /// **'Cost Saved: 35,000'**
  String get costSaved3;

  /// No description provided for @contentParagraph3.
  ///
  /// In en, this message translates to:
  /// **'See how Anil managed to save 40% more water using simple sensor-based drip irrigation systems in his arid region. This technology allowed him to automate watering schedules based on real-time soil moisture data, leading to significant water and labor savings.'**
  String get contentParagraph3;

  /// No description provided for @highlightText3.
  ///
  /// In en, this message translates to:
  /// **'The sensors are my eyes in the field. I know exactly when and how much to water my crops without any guesswork.'**
  String get highlightText3;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @earlySeason.
  ///
  /// In en, this message translates to:
  /// **'Early Season'**
  String get earlySeason;

  /// No description provided for @droughtResistant.
  ///
  /// In en, this message translates to:
  /// **'Drought Resistant'**
  String get droughtResistant;

  /// No description provided for @yieldRange1.
  ///
  /// In en, this message translates to:
  /// **'18-20%'**
  String get yieldRange1;

  /// No description provided for @resistantToRedRot.
  ///
  /// In en, this message translates to:
  /// **'Resistant to Red Rot'**
  String get resistantToRedRot;

  /// No description provided for @plantingRecommendationEarlyMid.
  ///
  /// In en, this message translates to:
  /// **'Best for early and mid-season planting.'**
  String get plantingRecommendationEarlyMid;

  /// No description provided for @yieldRange2.
  ///
  /// In en, this message translates to:
  /// **'19-21%'**
  String get yieldRange2;

  /// No description provided for @moderatelyResistantToRedRot.
  ///
  /// In en, this message translates to:
  /// **'Moderately resistant to Red Rot'**
  String get moderatelyResistantToRedRot;

  /// No description provided for @soilTypeLoamy.
  ///
  /// In en, this message translates to:
  /// **'Loamy soils'**
  String get soilTypeLoamy;

  /// No description provided for @sugarRecoveryHighEarlyCrushing.
  ///
  /// In en, this message translates to:
  /// **'High sugar recovery, excellent for early crushing.'**
  String get sugarRecoveryHighEarlyCrushing;

  /// No description provided for @yieldRange3.
  ///
  /// In en, this message translates to:
  /// **'18-19%'**
  String get yieldRange3;

  /// No description provided for @resistantToSmut.
  ///
  /// In en, this message translates to:
  /// **'Resistant to Smut'**
  String get resistantToSmut;

  /// No description provided for @soilTypeHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy soils'**
  String get soilTypeHeavy;

  /// No description provided for @highRainfallAreas.
  ///
  /// In en, this message translates to:
  /// **'Good for high rainfall areas.'**
  String get highRainfallAreas;

  /// No description provided for @yieldRange4.
  ///
  /// In en, this message translates to:
  /// **'17-18%'**
  String get yieldRange4;

  /// No description provided for @droughtSalinityTolerant.
  ///
  /// In en, this message translates to:
  /// **'Drought and Salinity tolerant'**
  String get droughtSalinityTolerant;

  /// No description provided for @soilTypeLightMedium.
  ///
  /// In en, this message translates to:
  /// **'Light to medium soils'**
  String get soilTypeLightMedium;

  /// No description provided for @waterStressedRegionsRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommended for water-stressed regions.'**
  String get waterStressedRegionsRecommendation;

  /// No description provided for @farmersStory.
  ///
  /// In en, this message translates to:
  /// **'Farmer\'s Story'**
  String get farmersStory;

  /// No description provided for @yieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Yield: '**
  String get yieldLabel;

  /// No description provided for @maturityLabel.
  ///
  /// In en, this message translates to:
  /// **'Maturity: '**
  String get maturityLabel;

  /// No description provided for @seeFullDetails.
  ///
  /// In en, this message translates to:
  /// **'See Full Details'**
  String get seeFullDetails;

  /// No description provided for @varietyDetails.
  ///
  /// In en, this message translates to:
  /// **'Variety Details'**
  String get varietyDetails;

  /// No description provided for @characteristicsTitle.
  ///
  /// In en, this message translates to:
  /// **'CHARACTERISTICS'**
  String get characteristicsTitle;

  /// No description provided for @noExpertRecommendation.
  ///
  /// In en, this message translates to:
  /// **'No expert recommendation available for this variety.'**
  String get noExpertRecommendation;

  /// No description provided for @averageYield.
  ///
  /// In en, this message translates to:
  /// **'Average Yield'**
  String get averageYield;

  /// No description provided for @sucrosePercentage.
  ///
  /// In en, this message translates to:
  /// **'Sucrose %'**
  String get sucrosePercentage;

  /// No description provided for @resistanceToPestsDiseases.
  ///
  /// In en, this message translates to:
  /// **'Resistance to Pests/Diseases'**
  String get resistanceToPestsDiseases;

  /// No description provided for @recommendedSoilType.
  ///
  /// In en, this message translates to:
  /// **'Recommended Soil Type'**
  String get recommendedSoilType;

  /// No description provided for @notAvailableAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailableAbbreviation;

  /// No description provided for @diagnosticDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Details'**
  String get diagnosticDetailsTitle;

  /// No description provided for @inDepthView.
  ///
  /// In en, this message translates to:
  /// **'In-Depth View'**
  String get inDepthView;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @remedies.
  ///
  /// In en, this message translates to:
  /// **'Remedies'**
  String get remedies;

  /// No description provided for @preventive.
  ///
  /// In en, this message translates to:
  /// **'Preventive'**
  String get preventive;

  /// No description provided for @biological.
  ///
  /// In en, this message translates to:
  /// **'Biological'**
  String get biological;

  /// No description provided for @chemical.
  ///
  /// In en, this message translates to:
  /// **'Chemical'**
  String get chemical;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @actionDescription.
  ///
  /// In en, this message translates to:
  /// **'Action / Description'**
  String get actionDescription;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @pestIdentification.
  ///
  /// In en, this message translates to:
  /// **'Pest Identification'**
  String get pestIdentification;

  /// No description provided for @pestIdentificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Identify and manage common pests affecting your crops.'**
  String get pestIdentificationDesc;

  /// No description provided for @pestIdentificationFooter.
  ///
  /// In en, this message translates to:
  /// **'View Pests'**
  String get pestIdentificationFooter;

  /// No description provided for @diseaseSymptomChecker.
  ///
  /// In en, this message translates to:
  /// **'Disease Symptom Checker'**
  String get diseaseSymptomChecker;

  /// No description provided for @diseaseSymptomCheckerDesc.
  ///
  /// In en, this message translates to:
  /// **'Check symptoms to identify diseases accurately.'**
  String get diseaseSymptomCheckerDesc;

  /// No description provided for @diseaseSymptomCheckerFooter.
  ///
  /// In en, this message translates to:
  /// **'Check Symptoms'**
  String get diseaseSymptomCheckerFooter;

  /// No description provided for @nutrientDeficiency.
  ///
  /// In en, this message translates to:
  /// **'Nutrient Deficiency'**
  String get nutrientDeficiency;

  /// No description provided for @nutrientDeficiencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Identify nutrient deficiencies and find remedies.'**
  String get nutrientDeficiencyDesc;

  /// No description provided for @nutrientDeficiencyFooter.
  ///
  /// In en, this message translates to:
  /// **'View Nutrients'**
  String get nutrientDeficiencyFooter;

  /// No description provided for @environmentalStress.
  ///
  /// In en, this message translates to:
  /// **'Environmental Stress'**
  String get environmentalStress;

  /// No description provided for @environmentalStressDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand and manage environmental stress factors.'**
  String get environmentalStressDesc;

  /// No description provided for @environmentalStressFooter.
  ///
  /// In en, this message translates to:
  /// **'View Stress Factors'**
  String get environmentalStressFooter;

  /// No description provided for @educationalVideosSubtitle.
  ///
  /// In en, this message translates to:
  /// **' Educational Videos'**
  String get educationalVideosSubtitle;

  /// No description provided for @filterButton.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterButton;

  /// No description provided for @stageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage '**
  String get stageLabel;

  /// No description provided for @guidanceLabel.
  ///
  /// In en, this message translates to:
  /// **' Guidance'**
  String get guidanceLabel;

  /// No description provided for @recommendedVarietiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **' Recommended Varieties'**
  String get recommendedVarietiesSubtitle;

  /// No description provided for @openDiagnosticsToolButton.
  ///
  /// In en, this message translates to:
  /// **' Open Diagnostics Tool'**
  String get openDiagnosticsToolButton;

  /// No description provided for @browseCourses.
  ///
  /// In en, this message translates to:
  /// **'Browse All Courses'**
  String get browseCourses;

  /// No description provided for @cropScience.
  ///
  /// In en, this message translates to:
  /// **'Crop Science'**
  String get cropScience;

  /// No description provided for @smartFarming.
  ///
  /// In en, this message translates to:
  /// **'Smart Farming'**
  String get smartFarming;

  /// No description provided for @soilHealth.
  ///
  /// In en, this message translates to:
  /// **'Soil Health'**
  String get soilHealth;

  /// No description provided for @videoLessons.
  ///
  /// In en, this message translates to:
  /// **'Video Lessons'**
  String get videoLessons;

  /// No description provided for @interactiveQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Interactive Quizzes'**
  String get interactiveQuizzes;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @fieldLearning.
  ///
  /// In en, this message translates to:
  /// **'Field Learning'**
  String get fieldLearning;

  /// No description provided for @localizedContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Localized Content'**
  String get localizedContentTitle;

  /// No description provided for @localizedContentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn in your own language.'**
  String get localizedContentSubtitle;

  /// No description provided for @practicalSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Practical Skills'**
  String get practicalSkillsTitle;

  /// No description provided for @practicalSkillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gain hands-on knowledge.'**
  String get practicalSkillsSubtitle;

  /// No description provided for @expertInstructorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Expert Instructors'**
  String get expertInstructorsTitle;

  /// No description provided for @expertInstructorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn from the best in the field.'**
  String get expertInstructorsSubtitle;

  /// No description provided for @trustedBy.
  ///
  /// In en, this message translates to:
  /// **'Trusted By'**
  String get trustedBy;

  /// No description provided for @khodwa.
  ///
  /// In en, this message translates to:
  /// **'Khodwa'**
  String get khodwa;

  /// No description provided for @suru.
  ///
  /// In en, this message translates to:
  /// **'Suru'**
  String get suru;

  /// No description provided for @adasali.
  ///
  /// In en, this message translates to:
  /// **'Adasali'**
  String get adasali;

  /// No description provided for @purvaHangami.
  ///
  /// In en, this message translates to:
  /// **'Purva Hangami'**
  String get purvaHangami;

  /// No description provided for @kharif.
  ///
  /// In en, this message translates to:
  /// **'Kharif'**
  String get kharif;

  /// No description provided for @cropOfTheMonth.
  ///
  /// In en, this message translates to:
  /// **'Crop of the Month'**
  String get cropOfTheMonth;

  /// No description provided for @sugarcaneTitle.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane (Co 86032)'**
  String get sugarcaneTitle;

  /// No description provided for @sugarcaneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'High-yielding, disease-resistant variety suitable for all regions.'**
  String get sugarcaneSubtitle;

  /// No description provided for @exploreDetails.
  ///
  /// In en, this message translates to:
  /// **'Explore Details'**
  String get exploreDetails;

  /// No description provided for @browseCrops.
  ///
  /// In en, this message translates to:
  /// **'Browse Crops'**
  String get browseCrops;

  /// No description provided for @highYield.
  ///
  /// In en, this message translates to:
  /// **'High Yield'**
  String get highYield;

  /// No description provided for @resilient.
  ///
  /// In en, this message translates to:
  /// **'Resilient'**
  String get resilient;

  /// No description provided for @waterIntensive.
  ///
  /// In en, this message translates to:
  /// **'Water Intensive'**
  String get waterIntensive;

  /// No description provided for @cashCrop.
  ///
  /// In en, this message translates to:
  /// **'Cash Crop'**
  String get cashCrop;

  /// No description provided for @proteinRich.
  ///
  /// In en, this message translates to:
  /// **'Protein Rich'**
  String get proteinRich;

  /// No description provided for @exportQuality.
  ///
  /// In en, this message translates to:
  /// **'Export Quality'**
  String get exportQuality;

  /// No description provided for @wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get wheat;

  /// No description provided for @maize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get maize;

  /// No description provided for @rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get rice;

  /// No description provided for @cotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cotton;

  /// No description provided for @soybeans.
  ///
  /// In en, this message translates to:
  /// **'Soybeans'**
  String get soybeans;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @grapes.
  ///
  /// In en, this message translates to:
  /// **'Grapes'**
  String get grapes;

  /// No description provided for @corn.
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get corn;

  /// No description provided for @chooseSeason.
  ///
  /// In en, this message translates to:
  /// **'Choose Season:'**
  String get chooseSeason;

  /// No description provided for @navigateToCropLifecycle.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Crop Lifecycle'**
  String get navigateToCropLifecycle;

  /// No description provided for @detailedImpactAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Detailed impact analysis'**
  String get detailedImpactAnalysis;

  /// No description provided for @commonDiseases.
  ///
  /// In en, this message translates to:
  /// **'Common Diseases'**
  String get commonDiseases;

  /// No description provided for @susceptibilityAndResistance.
  ///
  /// In en, this message translates to:
  /// **'Susceptibility and resistance'**
  String get susceptibilityAndResistance;

  /// No description provided for @commonPests.
  ///
  /// In en, this message translates to:
  /// **'Common Pests'**
  String get commonPests;

  /// No description provided for @potentialPestThreats.
  ///
  /// In en, this message translates to:
  /// **'Potential pest threats'**
  String get potentialPestThreats;

  /// No description provided for @nutrientRequirements.
  ///
  /// In en, this message translates to:
  /// **'Nutrient Requirements'**
  String get nutrientRequirements;

  /// No description provided for @recommendedNourishment.
  ///
  /// In en, this message translates to:
  /// **'Recommended nourishment'**
  String get recommendedNourishment;

  /// No description provided for @allSeasons.
  ///
  /// In en, this message translates to:
  /// **'All Seasons'**
  String get allSeasons;

  /// No description provided for @aiScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Instant Visual Diagnosis'**
  String get aiScannerTitle;

  /// No description provided for @aiScannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the affected crop for immediate AI analysis'**
  String get aiScannerSubtitle;

  /// No description provided for @aiScannerButton.
  ///
  /// In en, this message translates to:
  /// **'AI Scanner'**
  String get aiScannerButton;

  /// No description provided for @commonDeficiencies.
  ///
  /// In en, this message translates to:
  /// **'Common Deficiencies'**
  String get commonDeficiencies;

  /// No description provided for @detailedSymptomChecker.
  ///
  /// In en, this message translates to:
  /// **'Detailed Symptom Checker'**
  String get detailedSymptomChecker;

  /// No description provided for @soilTestingTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Testing & Nutrient Management'**
  String get soilTestingTitle;

  /// No description provided for @soilTestingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expert Guide • 8:45 mins'**
  String get soilTestingSubtitle;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watchVideo;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @noStoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No stories found'**
  String get noStoriesFound;

  /// No description provided for @noStressDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stress data available'**
  String get noStressDataAvailable;

  /// No description provided for @noCommonThreats.
  ///
  /// In en, this message translates to:
  /// **'No common threats reported'**
  String get noCommonThreats;

  /// No description provided for @noDiagnosticsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No diagnostics available'**
  String get noDiagnosticsAvailable;

  /// No description provided for @noDiseasesFound.
  ///
  /// In en, this message translates to:
  /// **'No diseases found'**
  String get noDiseasesFound;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @aiScannerHelper.
  ///
  /// In en, this message translates to:
  /// **'AI Scanner: Best results with close-ups'**
  String get aiScannerHelper;

  /// No description provided for @navigationError.
  ///
  /// In en, this message translates to:
  /// **'Navigation Error'**
  String get navigationError;

  /// No description provided for @searchVideosHint.
  ///
  /// In en, this message translates to:
  /// **'Search videos...'**
  String get searchVideosHint;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorLabel;

  /// No description provided for @recommendedVarieties.
  ///
  /// In en, this message translates to:
  /// **'Recommended Varieties'**
  String get recommendedVarieties;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @noCropsFound.
  ///
  /// In en, this message translates to:
  /// **'No crops found'**
  String get noCropsFound;

  /// No description provided for @videoGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Educational Videos'**
  String get videoGalleryTitle;

  /// No description provided for @filterCategories.
  ///
  /// In en, this message translates to:
  /// **'Filter Categories'**
  String get filterCategories;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @filterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a category to narrow down your search results.'**
  String get filterSubtitle;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @scannerQualityHint.
  ///
  /// In en, this message translates to:
  /// **'For better results, ensure the plant is well-lit and in focus.'**
  String get scannerQualityHint;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI Analyzing...'**
  String get aiAnalyzing;

  /// No description provided for @aiPlantDoctor.
  ///
  /// In en, this message translates to:
  /// **'AI Plant Doctor'**
  String get aiPlantDoctor;

  /// No description provided for @fitPlantInFrame.
  ///
  /// In en, this message translates to:
  /// **'Fit plant in frame'**
  String get fitPlantInFrame;

  /// No description provided for @identifyingDisease.
  ///
  /// In en, this message translates to:
  /// **'Identifying disease...'**
  String get identifyingDisease;

  /// No description provided for @retryScan.
  ///
  /// In en, this message translates to:
  /// **'Retry Scan'**
  String get retryScan;

  /// No description provided for @aiScannerTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Get closer to the affected area for better accuracy.'**
  String get aiScannerTip;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get views;

  /// No description provided for @academyName.
  ///
  /// In en, this message translates to:
  /// **'AgriBuddy Academy'**
  String get academyName;

  /// No description provided for @academySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expert Farming Guidance'**
  String get academySubtitle;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get upNext;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more...'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity:'**
  String get severityLabel;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @inDepthDetails.
  ///
  /// In en, this message translates to:
  /// **'In-depth Details'**
  String get inDepthDetails;

  /// No description provided for @educationalVideosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Educational Videos'**
  String educationalVideosCount(Object count);

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @watchOut.
  ///
  /// In en, this message translates to:
  /// **'Watch Out'**
  String get watchOut;

  /// No description provided for @commonThreats.
  ///
  /// In en, this message translates to:
  /// **'Common Threats'**
  String get commonThreats;

  /// No description provided for @seasonalRisksVigilance.
  ///
  /// In en, this message translates to:
  /// **'Stay vigilant against these seasonal risks.'**
  String get seasonalRisksVigilance;

  /// No description provided for @disease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get disease;

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get risk;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more...'**
  String get readMore;

  /// No description provided for @careInstruction.
  ///
  /// In en, this message translates to:
  /// **'Care Instruction'**
  String get careInstruction;

  /// No description provided for @highFertilizerLoad.
  ///
  /// In en, this message translates to:
  /// **'High Fertilizer Load'**
  String get highFertilizerLoad;

  /// No description provided for @riskOverFertilization.
  ///
  /// In en, this message translates to:
  /// **'Risk level increases with over-fertilization'**
  String get riskOverFertilization;

  /// No description provided for @fertilizerRequirements.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Requirements'**
  String get fertilizerRequirements;

  /// No description provided for @waterManagement.
  ///
  /// In en, this message translates to:
  /// **'Water Management'**
  String get waterManagement;

  /// No description provided for @riskIrrigationIssues.
  ///
  /// In en, this message translates to:
  /// **'Risk level increases with irrigation issues'**
  String get riskIrrigationIssues;

  /// No description provided for @filterCategoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Select a category to narrow down your search results.'**
  String get filterCategoryDescription;

  /// No description provided for @pest.
  ///
  /// In en, this message translates to:
  /// **'Pest'**
  String get pest;

  /// No description provided for @nutrient.
  ///
  /// In en, this message translates to:
  /// **'Nutrient'**
  String get nutrient;

  /// No description provided for @lifecycle.
  ///
  /// In en, this message translates to:
  /// **'Lifecycle'**
  String get lifecycle;

  /// No description provided for @viewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String viewsCount(Object count);

  /// No description provided for @expertFarmingGuidance.
  ///
  /// In en, this message translates to:
  /// **'Expert Farming Guidance'**
  String get expertFarmingGuidance;

  /// No description provided for @stageGuidanceTitle.
  ///
  /// In en, this message translates to:
  /// **'{number} Stage Guidance'**
  String stageGuidanceTitle(Object number);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'DURATION: {range} DAYS'**
  String durationDays(Object range);

  /// No description provided for @risksAndCare.
  ///
  /// In en, this message translates to:
  /// **'Risks & Care'**
  String get risksAndCare;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @climaticRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Climatic Requirements'**
  String get climaticRequirementsTitle;

  /// No description provided for @cropClimateRequirements.
  ///
  /// In en, this message translates to:
  /// **'{crop} Climate Requirements'**
  String cropClimateRequirements(Object crop);

  /// No description provided for @optimizedFarmingDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimized for sustainable {crop} farming and maximum sucrose accumulation.'**
  String optimizedFarmingDesc(Object crop);

  /// No description provided for @optimalClimateConditions.
  ///
  /// In en, this message translates to:
  /// **'Optimal Climate Conditions'**
  String get optimalClimateConditions;

  /// No description provided for @environmentalMetrics.
  ///
  /// In en, this message translates to:
  /// **'ENVIRONMENTAL METRICS'**
  String get environmentalMetrics;

  /// No description provided for @optimalTemp.
  ///
  /// In en, this message translates to:
  /// **'Optimal Temp'**
  String get optimalTemp;

  /// No description provided for @sunlightPath.
  ///
  /// In en, this message translates to:
  /// **'Sunlight Path'**
  String get sunlightPath;

  /// No description provided for @expertGuidance.
  ///
  /// In en, this message translates to:
  /// **'EXPERT GUIDANCE'**
  String get expertGuidance;

  /// No description provided for @growthStrategy.
  ///
  /// In en, this message translates to:
  /// **'Growth Strategy'**
  String get growthStrategy;

  /// No description provided for @photosynthesisOptimization.
  ///
  /// In en, this message translates to:
  /// **'Photosynthesis Optimization'**
  String get photosynthesisOptimization;

  /// No description provided for @moistureControl.
  ///
  /// In en, this message translates to:
  /// **'Moisture Control'**
  String get moistureControl;

  /// No description provided for @temperatureRisks.
  ///
  /// In en, this message translates to:
  /// **'Temperature Risks'**
  String get temperatureRisks;

  /// No description provided for @aiClimateAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Climate Analysis'**
  String get aiClimateAnalysis;

  /// No description provided for @atmosphericAdaptationDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep dive into {crop} atmospheric adaptation.'**
  String atmosphericAdaptationDesc(Object crop);

  /// No description provided for @soilPreparationTips.
  ///
  /// In en, this message translates to:
  /// **'Soil Preparation Tips'**
  String get soilPreparationTips;

  /// No description provided for @growthProgressSamples.
  ///
  /// In en, this message translates to:
  /// **'Growth Progress Samples'**
  String get growthProgressSamples;

  /// No description provided for @soilProgressSamples.
  ///
  /// In en, this message translates to:
  /// **'Soil Progress Samples'**
  String get soilProgressSamples;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @pestFilter.
  ///
  /// In en, this message translates to:
  /// **'Pest'**
  String get pestFilter;

  /// No description provided for @diseaseFilter.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get diseaseFilter;

  /// No description provided for @nutrientFilter.
  ///
  /// In en, this message translates to:
  /// **'Nutrient'**
  String get nutrientFilter;

  /// No description provided for @diseaseDetectedButNotFound.
  ///
  /// In en, this message translates to:
  /// **'Disease \"{name}\" detected but not found in database. Please update the app.'**
  String diseaseDetectedButNotFound(Object name);

  /// No description provided for @aiModelTimeout.
  ///
  /// In en, this message translates to:
  /// **'The AI model is trying its best but taking longer than expected. Please try again.'**
  String get aiModelTimeout;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @varietyIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Variety ID is required'**
  String get varietyIdRequired;

  /// No description provided for @diseaseDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Disease details not found'**
  String get diseaseDetailsNotFound;

  /// No description provided for @nutrientDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Nutrient details not found'**
  String get nutrientDetailsNotFound;

  /// No description provided for @detectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Detection failed'**
  String get detectionFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi', 'kn', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
