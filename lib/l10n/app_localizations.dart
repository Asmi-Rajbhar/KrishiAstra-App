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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KRISHIASTRA'**
  String get appTitle;

  /// No description provided for @splashTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track your farm with smart insights'**
  String get splashTitle1;

  /// No description provided for @splashSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Real-time monitoring and analytics for your crops'**
  String get splashSubtitle1;

  /// No description provided for @splashTitle2.
  ///
  /// In en, this message translates to:
  /// **'Detect crop diseases & get solutions'**
  String get splashTitle2;

  /// No description provided for @splashSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'AI-powered disease detection in seconds'**
  String get splashSubtitle2;

  /// No description provided for @splashTitle3.
  ///
  /// In en, this message translates to:
  /// **'Plan, predict, and grow better'**
  String get splashTitle3;

  /// No description provided for @splashSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Smart farming for sustainable agriculture'**
  String get splashSubtitle3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your journey'**
  String get loginSubtitle;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @usernameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get usernameError;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get passwordError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent!'**
  String get passwordResetSent;

  /// No description provided for @loginBtn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginBtn;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @newToApp.
  ///
  /// In en, this message translates to:
  /// **'New to KrishiAstra? '**
  String get newToApp;

  /// No description provided for @signUpFree.
  ///
  /// In en, this message translates to:
  /// **'Sign up for free'**
  String get signUpFree;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join our farming community today'**
  String get joinCommunity;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @phoneNum.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNum;

  /// No description provided for @locationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @tehsil.
  ///
  /// In en, this message translates to:
  /// **'Tehsil'**
  String get tehsil;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @digiPin.
  ///
  /// In en, this message translates to:
  /// **'DigiPIN'**
  String get digiPin;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @landCultivated.
  ///
  /// In en, this message translates to:
  /// **'Total Land Cultivated (acres)'**
  String get landCultivated;

  /// No description provided for @avgIncome.
  ///
  /// In en, this message translates to:
  /// **'Annual Average Income'**
  String get avgIncome;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @kycDocs.
  ///
  /// In en, this message translates to:
  /// **'KYC Documents'**
  String get kycDocs;

  /// No description provided for @aadhaarNum.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNum;

  /// No description provided for @panNum.
  ///
  /// In en, this message translates to:
  /// **'PAN Number'**
  String get panNum;

  /// No description provided for @uploadKyc.
  ///
  /// In en, this message translates to:
  /// **'Upload KYC Documents'**
  String get uploadKyc;

  /// No description provided for @filesSelected.
  ///
  /// In en, this message translates to:
  /// **'file(s) selected'**
  String get filesSelected;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @bankingInfo.
  ///
  /// In en, this message translates to:
  /// **'Banking Information'**
  String get bankingInfo;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// No description provided for @accountNum.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNum;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @addBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Another Bank Account'**
  String get addBankAccount;

  /// No description provided for @termsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to all the terms & conditions and privacy policy'**
  String get termsAgree;

  /// No description provided for @registerBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerBtn;

  /// No description provided for @registeringMsg.
  ///
  /// In en, this message translates to:
  /// **'Registering Farmer...'**
  String get registeringMsg;

  /// No description provided for @termsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept terms & conditions'**
  String get termsError;

  /// No description provided for @pleaseEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get pleaseEnter;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @fertilizerRec.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Recommendation'**
  String get fertilizerRec;

  /// No description provided for @expenseTracker.
  ///
  /// In en, this message translates to:
  /// **'Expense Tracker'**
  String get expenseTracker;

  /// No description provided for @disease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get disease;

  /// No description provided for @fertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizer;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer!'**
  String get farmer;

  /// No description provided for @cropsGrowingWell.
  ///
  /// In en, this message translates to:
  /// **'Your crops are growing well'**
  String get cropsGrowingWell;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @totalPlots.
  ///
  /// In en, this message translates to:
  /// **'Total Plots'**
  String get totalPlots;

  /// No description provided for @acres.
  ///
  /// In en, this message translates to:
  /// **'acres'**
  String get acres;

  /// No description provided for @weatherUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather\nUnavailable'**
  String get weatherUnavailable;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @myPlots.
  ///
  /// In en, this message translates to:
  /// **'My Plots'**
  String get myPlots;

  /// No description provided for @managePlots.
  ///
  /// In en, this message translates to:
  /// **'Manage your farm plots'**
  String get managePlots;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Full Details'**
  String get viewDetails;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @sowing.
  ///
  /// In en, this message translates to:
  /// **'Sowing'**
  String get sowing;

  /// No description provided for @harvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get harvest;

  /// No description provided for @plotMappingTitle.
  ///
  /// In en, this message translates to:
  /// **'Plot Mapping'**
  String get plotMappingTitle;

  /// No description provided for @searchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get searchLocationHint;

  /// No description provided for @minPointsError.
  ///
  /// In en, this message translates to:
  /// **'Please add at least 3 points to create a plot'**
  String get minPointsError;

  /// No description provided for @setLocationError.
  ///
  /// In en, this message translates to:
  /// **'Please set a location using search or GPS first'**
  String get setLocationError;

  /// No description provided for @locationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Location not found. Try another name.'**
  String get locationNotFound;

  /// No description provided for @locationFound.
  ///
  /// In en, this message translates to:
  /// **'Location found successfully!'**
  String get locationFound;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed. Check your connection.'**
  String get searchFailed;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationDisabled;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions denied.'**
  String get permissionDenied;

  /// No description provided for @permissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permissions permanently denied.'**
  String get permissionDeniedForever;

  /// No description provided for @locationDetected.
  ///
  /// In en, this message translates to:
  /// **'Your location detected!'**
  String get locationDetected;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Unable to retrieve location.'**
  String get locationError;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to start drawing'**
  String get tapToStart;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to add points'**
  String get tapToAdd;

  /// No description provided for @drawingMode.
  ///
  /// In en, this message translates to:
  /// **'Drawing Mode'**
  String get drawingMode;

  /// No description provided for @readyToMap.
  ///
  /// In en, this message translates to:
  /// **'Ready to Map'**
  String get readyToMap;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @stopDrawing.
  ///
  /// In en, this message translates to:
  /// **'Stop Drawing'**
  String get stopDrawing;

  /// No description provided for @startDrawing.
  ///
  /// In en, this message translates to:
  /// **'Start Drawing'**
  String get startDrawing;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @climateSoil.
  ///
  /// In en, this message translates to:
  /// **'Climate & Soil'**
  String get climateSoil;

  /// No description provided for @editPlot.
  ///
  /// In en, this message translates to:
  /// **'Edit Plot'**
  String get editPlot;

  /// No description provided for @plotInfo.
  ///
  /// In en, this message translates to:
  /// **'Plot Information'**
  String get plotInfo;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @cropPlantation.
  ///
  /// In en, this message translates to:
  /// **'Crop & Plantation'**
  String get cropPlantation;

  /// No description provided for @cropName.
  ///
  /// In en, this message translates to:
  /// **'Crop Name'**
  String get cropName;

  /// No description provided for @variety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get variety;

  /// No description provided for @sowingDate.
  ///
  /// In en, this message translates to:
  /// **'Sowing Date'**
  String get sowingDate;

  /// No description provided for @expectedHarvest.
  ///
  /// In en, this message translates to:
  /// **'Expected Harvest'**
  String get expectedHarvest;

  /// No description provided for @farmingType.
  ///
  /// In en, this message translates to:
  /// **'Farming Type'**
  String get farmingType;

  /// No description provided for @weatherDetails.
  ///
  /// In en, this message translates to:
  /// **'Weather Details'**
  String get weatherDetails;

  /// No description provided for @soilCondition.
  ///
  /// In en, this message translates to:
  /// **'Soil Condition'**
  String get soilCondition;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @cloudiness.
  ///
  /// In en, this message translates to:
  /// **'Cloudiness'**
  String get cloudiness;

  /// No description provided for @moisture.
  ///
  /// In en, this message translates to:
  /// **'Moisture'**
  String get moisture;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @phLevel.
  ///
  /// In en, this message translates to:
  /// **'pH Level'**
  String get phLevel;

  /// No description provided for @nitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N)'**
  String get nitrogen;

  /// No description provided for @weatherLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load weather data.'**
  String get weatherLoadError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Check connection.'**
  String get connectionError;

  /// No description provided for @addPlotDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Plot Details'**
  String get addPlotDetails;

  /// No description provided for @plotSavedMsg.
  ///
  /// In en, this message translates to:
  /// **'Plot details saved successfully!'**
  String get plotSavedMsg;

  /// No description provided for @farmName.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// No description provided for @farmNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your farm name'**
  String get farmNameHint;

  /// No description provided for @cropNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Wheat, Rice, Cotton'**
  String get cropNameHint;

  /// No description provided for @cropVariety.
  ///
  /// In en, this message translates to:
  /// **'Crop Variety'**
  String get cropVariety;

  /// No description provided for @cropVarietyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter crop variety'**
  String get cropVarietyHint;

  /// No description provided for @irrigationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of Irrigation'**
  String get irrigationTypeLabel;

  /// No description provided for @farmingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of Farming'**
  String get farmingTypeLabel;

  /// No description provided for @sowingDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select sowing date'**
  String get sowingDateHint;

  /// No description provided for @selectDateError.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get selectDateError;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @selectOptionHint.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectOptionHint;

  /// No description provided for @selectOptionError.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get selectOptionError;

  /// No description provided for @savePlotDetails.
  ///
  /// In en, this message translates to:
  /// **'Save Plot Details'**
  String get savePlotDetails;

  /// No description provided for @plotLocation.
  ///
  /// In en, this message translates to:
  /// **'Plot Location'**
  String get plotLocation;

  /// No description provided for @totalArea.
  ///
  /// In en, this message translates to:
  /// **'Total Area'**
  String get totalArea;

  /// No description provided for @drip.
  ///
  /// In en, this message translates to:
  /// **'Drip'**
  String get drip;

  /// No description provided for @sprinkler.
  ///
  /// In en, this message translates to:
  /// **'Sprinkler'**
  String get sprinkler;

  /// No description provided for @flood.
  ///
  /// In en, this message translates to:
  /// **'Flood'**
  String get flood;

  /// No description provided for @canal.
  ///
  /// In en, this message translates to:
  /// **'Canal'**
  String get canal;

  /// No description provided for @organic.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get organic;

  /// No description provided for @conventional.
  ///
  /// In en, this message translates to:
  /// **'Conventional'**
  String get conventional;

  /// No description provided for @hydroponic.
  ///
  /// In en, this message translates to:
  /// **'Hydroponic'**
  String get hydroponic;

  /// No description provided for @noTill.
  ///
  /// In en, this message translates to:
  /// **'No-Till'**
  String get noTill;

  /// No description provided for @plantDiseaseScanner.
  ///
  /// In en, this message translates to:
  /// **'Plant Disease Scanner'**
  String get plantDiseaseScanner;

  /// No description provided for @identifyDiseases.
  ///
  /// In en, this message translates to:
  /// **'Identify Plant Diseases Instantly'**
  String get identifyDiseases;

  /// No description provided for @scanDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your camera to scan a plant leaf and get an instant analysis of its health.'**
  String get scanDescription;

  /// No description provided for @startScanning.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// No description provided for @procStatusAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Plant...'**
  String get procStatusAnalyzing;

  /// No description provided for @procStep1.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Checking for leaf...'**
  String get procStep1;

  /// No description provided for @procStep1Sub.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image colors'**
  String get procStep1Sub;

  /// No description provided for @procErrorNotLeaf.
  ///
  /// In en, this message translates to:
  /// **'Not a Leaf. Please upload a clear image of a plant leaf.'**
  String get procErrorNotLeaf;

  /// No description provided for @procStep2.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Detecting disease...'**
  String get procStep2;

  /// No description provided for @procStep2Sub.
  ///
  /// In en, this message translates to:
  /// **'Contacting analysis server'**
  String get procStep2Sub;

  /// No description provided for @procComplete.
  ///
  /// In en, this message translates to:
  /// **'Analysis Complete!'**
  String get procComplete;

  /// No description provided for @procFailed.
  ///
  /// In en, this message translates to:
  /// **'Processing Failed'**
  String get procFailed;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Scanner'**
  String get scanTitle;

  /// No description provided for @scanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast leaf detection • Fertilizer tips'**
  String get scanSubtitle;

  /// No description provided for @scanBadgeBeta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get scanBadgeBeta;

  /// No description provided for @scanHintAlign.
  ///
  /// In en, this message translates to:
  /// **'Align the leaf inside the frame'**
  String get scanHintAlign;

  /// No description provided for @scanBtnHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get scanBtnHome;

  /// No description provided for @scanBtnGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get scanBtnGuide;

  /// No description provided for @scanBtnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get scanBtnClose;

  /// No description provided for @scanBtnGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get scanBtnGallery;

  /// No description provided for @scanGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanning tips'**
  String get scanGuideTitle;

  /// No description provided for @scanGuideMessage.
  ///
  /// In en, this message translates to:
  /// **'Place the leaf flat, avoid shadows, and keep the camera steady for best results.'**
  String get scanGuideMessage;

  /// No description provided for @scanGuideGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get scanGuideGotIt;

  /// No description provided for @healthyResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get healthyResultTitle;

  /// No description provided for @healthyStatus.
  ///
  /// In en, this message translates to:
  /// **'Plant is Healthy'**
  String get healthyStatus;

  /// No description provided for @healthySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No disease detected. Keep up the great care!'**
  String get healthySubtitle;

  /// No description provided for @healthyActionScan.
  ///
  /// In en, this message translates to:
  /// **'Scan Another Plant'**
  String get healthyActionScan;

  /// No description provided for @drTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis Report'**
  String get drTitle;

  /// No description provided for @drDetectedIssue.
  ///
  /// In en, this message translates to:
  /// **'Detected Issue'**
  String get drDetectedIssue;

  /// No description provided for @drConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get drConfidence;

  /// No description provided for @drAiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI RECOMMENDATIONS'**
  String get drAiRecommendations;

  /// No description provided for @drLoading.
  ///
  /// In en, this message translates to:
  /// **'Consulting Agricultural Knowledge Base...'**
  String get drLoading;

  /// No description provided for @drErrorFetch.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch treatments. Please check your connection.'**
  String get drErrorFetch;

  /// No description provided for @drBtnScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Another Plant'**
  String get drBtnScanAgain;

  /// No description provided for @drCardDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get drCardDiagnosis;

  /// No description provided for @drCardCause.
  ///
  /// In en, this message translates to:
  /// **'Root Cause'**
  String get drCardCause;

  /// No description provided for @drCardOrganic.
  ///
  /// In en, this message translates to:
  /// **'Organic Solution'**
  String get drCardOrganic;

  /// No description provided for @drCardChemical.
  ///
  /// In en, this message translates to:
  /// **'Chemical Solution'**
  String get drCardChemical;

  /// No description provided for @drCardFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get drCardFertilizer;

  /// No description provided for @drCardPrevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get drCardPrevention;

  /// No description provided for @profitTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Profit Tracker'**
  String get profitTrackerTitle;

  /// No description provided for @cropDetails.
  ///
  /// In en, this message translates to:
  /// **'Crop Details'**
  String get cropDetails;

  /// No description provided for @selectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get selectCrop;

  /// No description provided for @yieldType.
  ///
  /// In en, this message translates to:
  /// **'Yield Type'**
  String get yieldType;

  /// No description provided for @harvestDate.
  ///
  /// In en, this message translates to:
  /// **'Harvest Date'**
  String get harvestDate;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @expenseType.
  ///
  /// In en, this message translates to:
  /// **'Expense Type'**
  String get expenseType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @addBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addBtn;

  /// No description provided for @expenseList.
  ///
  /// In en, this message translates to:
  /// **'Expense List'**
  String get expenseList;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses added yet'**
  String get noExpenses;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @yieldAndSale.
  ///
  /// In en, this message translates to:
  /// **'Yield & Sale'**
  String get yieldAndSale;

  /// No description provided for @totalYield.
  ///
  /// In en, this message translates to:
  /// **'Total Yield'**
  String get totalYield;

  /// No description provided for @yieldUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get yieldUnit;

  /// No description provided for @quantitySold.
  ///
  /// In en, this message translates to:
  /// **'Quantity Sold'**
  String get quantitySold;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per Unit'**
  String get pricePerUnit;

  /// No description provided for @saleDate.
  ///
  /// In en, this message translates to:
  /// **'Sale Date'**
  String get saleDate;

  /// No description provided for @calculateProfit.
  ///
  /// In en, this message translates to:
  /// **'Calculate Profit'**
  String get calculateProfit;

  /// No description provided for @profitResult.
  ///
  /// In en, this message translates to:
  /// **'Profit Result'**
  String get profitResult;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @netLoss.
  ///
  /// In en, this message translates to:
  /// **'Net Loss'**
  String get netLoss;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @enterSaleDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter valid sale details'**
  String get enterSaleDetails;

  /// No description provided for @cropRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get cropRice;

  /// No description provided for @cropWheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get cropWheat;

  /// No description provided for @cropCorn.
  ///
  /// In en, this message translates to:
  /// **'Corn (Maize)'**
  String get cropCorn;

  /// No description provided for @cropSorghum.
  ///
  /// In en, this message translates to:
  /// **'Sorghum'**
  String get cropSorghum;

  /// No description provided for @cropMillet.
  ///
  /// In en, this message translates to:
  /// **'Millet'**
  String get cropMillet;

  /// No description provided for @cropSugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get cropSugarcane;

  /// No description provided for @cropTomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get cropTomato;

  /// No description provided for @cropPotato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get cropPotato;

  /// No description provided for @cropBrinjal.
  ///
  /// In en, this message translates to:
  /// **'Brinjal'**
  String get cropBrinjal;

  /// No description provided for @cropCapsicum.
  ///
  /// In en, this message translates to:
  /// **'Capsicum'**
  String get cropCapsicum;

  /// No description provided for @yieldTypeGrain.
  ///
  /// In en, this message translates to:
  /// **'Grain'**
  String get yieldTypeGrain;

  /// No description provided for @yieldTypeVegetable.
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get yieldTypeVegetable;

  /// No description provided for @yieldTypeFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get yieldTypeFruit;

  /// No description provided for @yieldTypeFiber.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get yieldTypeFiber;

  /// No description provided for @expSeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get expSeeds;

  /// No description provided for @expFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get expFertilizer;

  /// No description provided for @expLabor.
  ///
  /// In en, this message translates to:
  /// **'Labor'**
  String get expLabor;

  /// No description provided for @expIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get expIrrigation;

  /// No description provided for @expMachinery.
  ///
  /// In en, this message translates to:
  /// **'Machinery'**
  String get expMachinery;

  /// No description provided for @expTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expTransport;

  /// No description provided for @expOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expOther;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get unitKg;

  /// No description provided for @unitQuintal.
  ///
  /// In en, this message translates to:
  /// **'Quintal'**
  String get unitQuintal;

  /// No description provided for @unitTon.
  ///
  /// In en, this message translates to:
  /// **'Ton'**
  String get unitTon;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneHint;

  /// No description provided for @phoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get phoneError;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeUser;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred:'**
  String get unexpectedError;

  /// No description provided for @fetchUserError.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch user details'**
  String get fetchUserError;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @verificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification Required'**
  String get verificationRequired;

  /// No description provided for @verifyPlotMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to verify yourself before creating a plot'**
  String get verifyPlotMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, '**
  String get welcome;

  /// No description provided for @university.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// No description provided for @whatsTheWeather.
  ///
  /// In en, this message translates to:
  /// **'What\'s the weather?'**
  String get whatsTheWeather;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidityLabel;

  /// No description provided for @windLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windLabel;

  /// No description provided for @noPlotsFound.
  ///
  /// In en, this message translates to:
  /// **'No plots found. Please add a plot first.'**
  String get noPlotsFound;

  /// No description provided for @myCropsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Crops'**
  String get myCropsTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noCropsAdded.
  ///
  /// In en, this message translates to:
  /// **'No crops added yet'**
  String get noCropsAdded;

  /// No description provided for @cropFallback.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get cropFallback;

  /// No description provided for @cropCotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cropCotton;

  /// No description provided for @smartFarmingTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Farming'**
  String get smartFarmingTitle;

  /// No description provided for @trackerLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get trackerLabel;

  /// No description provided for @analyticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsLabel;

  /// No description provided for @cropwellExpert.
  ///
  /// In en, this message translates to:
  /// **'Cropwell Expert'**
  String get cropwellExpert;

  /// No description provided for @cropPredictor.
  ///
  /// In en, this message translates to:
  /// **'Crop Predictor'**
  String get cropPredictor;

  /// No description provided for @marketPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Market & Policy'**
  String get marketPolicyTitle;

  /// No description provided for @priceTrendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Price Trend Analysis'**
  String get priceTrendAnalysis;

  /// No description provided for @cropSchemeSuitability.
  ///
  /// In en, this message translates to:
  /// **'Crop & Scheme Suitability'**
  String get cropSchemeSuitability;

  /// No description provided for @recommendedVideos.
  ///
  /// In en, this message translates to:
  /// **'Recommended Videos'**
  String get recommendedVideos;

  /// No description provided for @videoTitle1.
  ///
  /// In en, this message translates to:
  /// **'Best practices for sugarcane irrigation in summer'**
  String get videoTitle1;

  /// No description provided for @videoTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart farming techniques for higher yield'**
  String get videoTitle2;

  /// No description provided for @videoTitle3.
  ///
  /// In en, this message translates to:
  /// **'Organic farming methods'**
  String get videoTitle3;

  /// No description provided for @createYourAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccountSubtitle;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Please login.'**
  String get accountCreatedSuccess;

  /// No description provided for @soilAlluvial.
  ///
  /// In en, this message translates to:
  /// **'Alluvial Soil'**
  String get soilAlluvial;

  /// No description provided for @soilBlack.
  ///
  /// In en, this message translates to:
  /// **'Black Soil (Regur Soil)'**
  String get soilBlack;

  /// No description provided for @soilRed.
  ///
  /// In en, this message translates to:
  /// **'Red Soil'**
  String get soilRed;

  /// No description provided for @soilLaterite.
  ///
  /// In en, this message translates to:
  /// **'Laterite Soil'**
  String get soilLaterite;

  /// No description provided for @soilArid.
  ///
  /// In en, this message translates to:
  /// **'Arid (Desert) Soil'**
  String get soilArid;

  /// No description provided for @soilMountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain (Forest) Soil'**
  String get soilMountain;

  /// No description provided for @soilSaline.
  ///
  /// In en, this message translates to:
  /// **'Saline and Alkaline Soil'**
  String get soilSaline;

  /// No description provided for @soilOther.
  ///
  /// In en, this message translates to:
  /// **'Other (type it)'**
  String get soilOther;

  /// No description provided for @selectSoilType.
  ///
  /// In en, this message translates to:
  /// **'Select soil type'**
  String get selectSoilType;

  /// No description provided for @describeSoilType.
  ///
  /// In en, this message translates to:
  /// **'Describe your soil type...'**
  String get describeSoilType;

  /// No description provided for @pleaseDescribeSoil.
  ///
  /// In en, this message translates to:
  /// **'Please describe the soil type'**
  String get pleaseDescribeSoil;

  /// No description provided for @invalidDateError.
  ///
  /// In en, this message translates to:
  /// **'Please pick a valid sowing date'**
  String get invalidDateError;

  /// No description provided for @selectIrrigationError.
  ///
  /// In en, this message translates to:
  /// **'Please select irrigation type'**
  String get selectIrrigationError;

  /// No description provided for @selectFarmingError.
  ///
  /// In en, this message translates to:
  /// **'Please select farming type'**
  String get selectFarmingError;

  /// No description provided for @selectSoilError.
  ///
  /// In en, this message translates to:
  /// **'Please select or enter soil type'**
  String get selectSoilError;

  /// No description provided for @unexpectedServerError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected server response'**
  String get unexpectedServerError;

  /// No description provided for @errorSavingPlot.
  ///
  /// In en, this message translates to:
  /// **'Error saving plot: '**
  String get errorSavingPlot;
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
