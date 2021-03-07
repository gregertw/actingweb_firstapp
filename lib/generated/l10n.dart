// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ActingWeb First App`
  String get appTitle {
    return Intl.message(
      'ActingWeb First App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to ActingWeb`
  String get loginWelcomeText {
    return Intl.message(
      'Welcome to ActingWeb',
      name: 'loginWelcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Loading events...`
  String get loginLoadEvents {
    return Intl.message(
      'Loading events...',
      name: 'loginLoadEvents',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get loginButton {
    return Intl.message(
      'Log in',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logoutButton {
    return Intl.message(
      'Log out',
      name: 'logoutButton',
      desc: '',
      args: [],
    );
  }

  /// `Start listening`
  String get startListening {
    return Intl.message(
      'Start listening',
      name: 'startListening',
      desc: '',
      args: [],
    );
  }

  /// `Stop listening`
  String get stopListening {
    return Intl.message(
      'Stop listening',
      name: 'stopListening',
      desc: '',
      args: [],
    );
  }

  /// `Lat: $lat, Long: $long`
  String get latitudeLongitude {
    return Intl.message(
      'Lat: \$lat, Long: \$long',
      name: 'latitudeLongitude',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get okButton {
    return Intl.message(
      'Ok',
      name: 'okButton',
      desc: '',
      args: [],
    );
  }

  /// `Click to view...`
  String get clickToView {
    return Intl.message(
      'Click to view...',
      name: 'clickToView',
      desc: '',
      args: [],
    );
  }

  /// `testuser@demoserver.io`
  String get drawerEmail {
    return Intl.message(
      'testuser@demoserver.io',
      name: 'drawerEmail',
      desc: '',
      args: [],
    );
  }

  /// `Test User`
  String get drawerUser {
    return Intl.message(
      'Test User',
      name: 'drawerUser',
      desc: '',
      args: [],
    );
  }

  /// `Click to view details...`
  String get drawerHeaderInitialName {
    return Intl.message(
      'Click to view details...',
      name: 'drawerHeaderInitialName',
      desc: '',
      args: [],
    );
  }

  /// `...`
  String get drawerHeaderInitialEmail {
    return Intl.message(
      '...',
      name: 'drawerHeaderInitialEmail',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get drawerEmptyName {
    return Intl.message(
      'N/A',
      name: 'drawerEmptyName',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get drawerEmptyEmail {
    return Intl.message(
      '',
      name: 'drawerEmptyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Refresh tokens`
  String get drawerRefreshTokens {
    return Intl.message(
      'Refresh tokens',
      name: 'drawerRefreshTokens',
      desc: '',
      args: [],
    );
  }

  /// `Tokens refreshed`
  String get drawerRefreshTokensResultTitle {
    return Intl.message(
      'Tokens refreshed',
      name: 'drawerRefreshTokensResultTitle',
      desc: '',
      args: [],
    );
  }

  /// `See user details for the new tokens.`
  String get drawerRefreshTokensResultMsg {
    return Intl.message(
      'See user details for the new tokens.',
      name: 'drawerRefreshTokensResultMsg',
      desc: '',
      args: [],
    );
  }

  /// `Get user info`
  String get drawerGetUserInfo {
    return Intl.message(
      'Get user info',
      name: 'drawerGetUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `User info retrieved`
  String get drawerGetUserInfoResultTitle {
    return Intl.message(
      'User info retrieved',
      name: 'drawerGetUserInfoResultTitle',
      desc: '',
      args: [],
    );
  }

  /// `User details have been updated.`
  String get drawerGetUserInfoResultMsg {
    return Intl.message(
      'User details have been updated.',
      name: 'drawerGetUserInfoResultMsg',
      desc: '',
      args: [],
    );
  }

  /// `User info retrieval failed`
  String get drawerGetUserInfoFailedTitle {
    return Intl.message(
      'User info retrieval failed',
      name: 'drawerGetUserInfoFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Try to refresh token first!`
  String get drawerGetUserInfoFailedMsg {
    return Intl.message(
      'Try to refresh token first!',
      name: 'drawerGetUserInfoFailedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Current localisation`
  String get drawerLocalisation {
    return Intl.message(
      'Current localisation',
      name: 'drawerLocalisation',
      desc: '',
      args: [],
    );
  }

  /// `Locale changed`
  String get drawerLocalisationResultTitle {
    return Intl.message(
      'Locale changed',
      name: 'drawerLocalisationResultTitle',
      desc: '',
      args: [],
    );
  }

  /// `Changed to `
  String get drawerLocalisationResultMsg {
    return Intl.message(
      'Changed to ',
      name: 'drawerLocalisationResultMsg',
      desc: '',
      args: [],
    );
  }

  /// `User token`
  String get drawerButtomSheetUserToken {
    return Intl.message(
      'User token',
      name: 'drawerButtomSheetUserToken',
      desc: '',
      args: [],
    );
  }

  /// `Id token`
  String get drawerButtomSheetIdToken {
    return Intl.message(
      'Id token',
      name: 'drawerButtomSheetIdToken',
      desc: '',
      args: [],
    );
  }

  /// `Firebase messaging token`
  String get drawerButtomSheetFCMToken {
    return Intl.message(
      'Firebase messaging token',
      name: 'drawerButtomSheetFCMToken',
      desc: '',
      args: [],
    );
  }

  /// `Expires`
  String get drawerButtomSheetExpires {
    return Intl.message(
      'Expires',
      name: 'drawerButtomSheetExpires',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'nb'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}