// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ActingWeb First App';

  @override
  String get loginWelcomeText => 'Welcome to ActingWeb';

  @override
  String get loginLoadEvents => 'Loading events...';

  @override
  String get loginButton_Github => 'Log in with GitHub';

  @override
  String get loginButton_Google => 'Log in with Google';

  @override
  String get logoutButton => 'Log out';

  @override
  String get startListening => 'Start listening';

  @override
  String get stopListening => 'Stop listening';

  @override
  String get latitudeLongitude => 'Lat: \$lat, Long: \$long';

  @override
  String get unknown => 'Unknown';

  @override
  String get okButton => 'Ok';

  @override
  String get clickToView => 'Click to view...';

  @override
  String get drawerEmail => 'testuser@demoserver.io';

  @override
  String get drawerUser => 'Test User';

  @override
  String get drawerHeaderInitialName => 'Click to view details...';

  @override
  String get drawerHeaderInitialEmail => '...';

  @override
  String get drawerEmptyName => 'N/A';

  @override
  String get drawerEmptyEmail => '';

  @override
  String get drawerRefreshTokens => 'Refresh tokens';

  @override
  String get drawerRefreshTokensResultTitle => 'Tokens refreshed';

  @override
  String get drawerRefreshTokensResultMsg => 'See user details for the new tokens.';

  @override
  String get drawerGetUserInfo => 'Get user info';

  @override
  String get drawerGetUserInfoResultTitle => 'User info retrieved';

  @override
  String get drawerGetUserInfoResultMsg => 'User details have been updated.';

  @override
  String get drawerGetUserInfoFailedTitle => 'User info retrieval failed';

  @override
  String get drawerGetUserInfoFailedMsg => 'Try to refresh token first!';

  @override
  String get drawerLocalisation => 'Current localisation';

  @override
  String get drawerLocalisationResultTitle => 'Locale changed';

  @override
  String get drawerLocalisationResultMsg => 'Changed to ';

  @override
  String get drawerButtomSheetUserToken => 'User token';

  @override
  String get drawerButtomSheetIdToken => 'Id token';

  @override
  String get drawerButtomSheetFCMToken => 'Firebase messaging token';

  @override
  String get drawerButtomSheetExpires => 'Expires';

  @override
  String get drawerGetLastNotification => 'See last notification';

  @override
  String get locationNotAvailableHeader => 'No access to location!';

  @override
  String get locationNotAvailable => 'Your application is not allowed to get location data from your device. Please go to app configurations and allow location information.';
}
