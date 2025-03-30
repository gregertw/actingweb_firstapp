import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nb.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nb')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ActingWeb First App'**
  String get appTitle;

  /// No description provided for @loginWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ActingWeb'**
  String get loginWelcomeText;

  /// No description provided for @loginLoadEvents.
  ///
  /// In en, this message translates to:
  /// **'Loading events...'**
  String get loginLoadEvents;

  /// No description provided for @loginButton_Github.
  ///
  /// In en, this message translates to:
  /// **'Log in with GitHub'**
  String get loginButton_Github;

  /// No description provided for @loginButton_Google.
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get loginButton_Google;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButton;

  /// No description provided for @startListening.
  ///
  /// In en, this message translates to:
  /// **'Start listening'**
  String get startListening;

  /// No description provided for @stopListening.
  ///
  /// In en, this message translates to:
  /// **'Stop listening'**
  String get stopListening;

  /// No description provided for @latitudeLongitude.
  ///
  /// In en, this message translates to:
  /// **'Lat: \$lat, Long: \$long'**
  String get latitudeLongitude;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okButton;

  /// No description provided for @clickToView.
  ///
  /// In en, this message translates to:
  /// **'Click to view...'**
  String get clickToView;

  /// No description provided for @drawerEmail.
  ///
  /// In en, this message translates to:
  /// **'testuser@demoserver.io'**
  String get drawerEmail;

  /// No description provided for @drawerUser.
  ///
  /// In en, this message translates to:
  /// **'Test User'**
  String get drawerUser;

  /// No description provided for @drawerHeaderInitialName.
  ///
  /// In en, this message translates to:
  /// **'Click to view details...'**
  String get drawerHeaderInitialName;

  /// No description provided for @drawerHeaderInitialEmail.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get drawerHeaderInitialEmail;

  /// No description provided for @drawerEmptyName.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get drawerEmptyName;

  /// No description provided for @drawerEmptyEmail.
  ///
  /// In en, this message translates to:
  /// **''**
  String get drawerEmptyEmail;

  /// No description provided for @drawerRefreshTokens.
  ///
  /// In en, this message translates to:
  /// **'Refresh tokens'**
  String get drawerRefreshTokens;

  /// No description provided for @drawerRefreshTokensResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Tokens refreshed'**
  String get drawerRefreshTokensResultTitle;

  /// No description provided for @drawerRefreshTokensResultMsg.
  ///
  /// In en, this message translates to:
  /// **'See user details for the new tokens.'**
  String get drawerRefreshTokensResultMsg;

  /// No description provided for @drawerGetUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Get user info'**
  String get drawerGetUserInfo;

  /// No description provided for @drawerGetUserInfoResultTitle.
  ///
  /// In en, this message translates to:
  /// **'User info retrieved'**
  String get drawerGetUserInfoResultTitle;

  /// No description provided for @drawerGetUserInfoResultMsg.
  ///
  /// In en, this message translates to:
  /// **'User details have been updated.'**
  String get drawerGetUserInfoResultMsg;

  /// No description provided for @drawerGetUserInfoFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'User info retrieval failed'**
  String get drawerGetUserInfoFailedTitle;

  /// No description provided for @drawerGetUserInfoFailedMsg.
  ///
  /// In en, this message translates to:
  /// **'Try to refresh token first!'**
  String get drawerGetUserInfoFailedMsg;

  /// No description provided for @drawerLocalisation.
  ///
  /// In en, this message translates to:
  /// **'Current localisation'**
  String get drawerLocalisation;

  /// No description provided for @drawerLocalisationResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Locale changed'**
  String get drawerLocalisationResultTitle;

  /// No description provided for @drawerLocalisationResultMsg.
  ///
  /// In en, this message translates to:
  /// **'Changed to '**
  String get drawerLocalisationResultMsg;

  /// No description provided for @drawerButtomSheetUserToken.
  ///
  /// In en, this message translates to:
  /// **'User token'**
  String get drawerButtomSheetUserToken;

  /// No description provided for @drawerButtomSheetIdToken.
  ///
  /// In en, this message translates to:
  /// **'Id token'**
  String get drawerButtomSheetIdToken;

  /// No description provided for @drawerButtomSheetFCMToken.
  ///
  /// In en, this message translates to:
  /// **'Firebase messaging token'**
  String get drawerButtomSheetFCMToken;

  /// No description provided for @drawerButtomSheetExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get drawerButtomSheetExpires;

  /// No description provided for @drawerGetLastNotification.
  ///
  /// In en, this message translates to:
  /// **'See last notification'**
  String get drawerGetLastNotification;

  /// No description provided for @locationNotAvailableHeader.
  ///
  /// In en, this message translates to:
  /// **'No access to location!'**
  String get locationNotAvailableHeader;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Your application is not allowed to get location data from your device. Please go to app configurations and allow location information.'**
  String get locationNotAvailable;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'nb'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'nb': return AppLocalizationsNb();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
