// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'ActingWeb Første App';

  @override
  String get loginWelcomeText => 'Velkommen til ActingWeb';

  @override
  String get loginLoadEvents => 'Henter meldinger...';

  @override
  String get loginButton_Github => 'Logg inn med GitHub';

  @override
  String get loginButton_Google => 'Logg inn med Google';

  @override
  String get logoutButton => 'Logg ut';

  @override
  String get startListening => 'Start lytting';

  @override
  String get stopListening => 'Stopp lytting';

  @override
  String get latitudeLongitude => 'Lat: \$lat, Long: \$long';

  @override
  String get unknown => 'Ukjent';

  @override
  String get okButton => 'Ok';

  @override
  String get clickToView => 'Trykk for å se...';

  @override
  String get drawerEmail => 'testuser@demoserver.io';

  @override
  String get drawerUser => 'Test Bruker';

  @override
  String get drawerHeaderInitialName => 'Klikk for å se detaljer...';

  @override
  String get drawerHeaderInitialEmail => '...';

  @override
  String get drawerEmptyName => 'N/A';

  @override
  String get drawerEmptyEmail => '';

  @override
  String get drawerRefreshTokens => 'Oppfrisk tokens';

  @override
  String get drawerRefreshTokensResultTitle => 'Tokens oppfrisket';

  @override
  String get drawerRefreshTokensResultMsg => 'Se bruker detaljer for oppdaterte token.';

  @override
  String get drawerGetUserInfo => 'Hent brukerinformasjon';

  @override
  String get drawerGetUserInfoResultTitle => 'Brukerinformasjon oppdatert';

  @override
  String get drawerGetUserInfoResultMsg => 'Brukerinformasjon har blitt oppdatert.';

  @override
  String get drawerGetUserInfoFailedTitle => 'Henting av brukerinformasjon feilet';

  @override
  String get drawerGetUserInfoFailedMsg => 'Forsøk å oppfrisk tokens først!';

  @override
  String get drawerLocalisation => 'Nåværende lokalisering';

  @override
  String get drawerLocalisationResultTitle => 'Lokalisering endret';

  @override
  String get drawerLocalisationResultMsg => 'Endret til ';

  @override
  String get drawerButtomSheetUserToken => 'Bruker token';

  @override
  String get drawerButtomSheetIdToken => 'Id token';

  @override
  String get drawerButtomSheetFCMToken => 'Firebase meldingstoken';

  @override
  String get drawerButtomSheetExpires => 'Utløper';

  @override
  String get drawerGetLastNotification => 'Se siste melding';

  @override
  String get locationNotAvailableHeader => 'Lokasjonsposisjon ikke tillatt!';

  @override
  String get locationNotAvailable => 'Applikasjonen får ikke tilgang til lokasjonsdata fra mobilen din. Gå til innstillinger for applikasjoner for å tillate lokasjon.';
}
