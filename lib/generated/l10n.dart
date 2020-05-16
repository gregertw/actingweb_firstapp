// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appTitle {
    return Intl.message(
      'ActingWeb First App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  String get loginWelcomeText {
    return Intl.message(
      'Welcome to ActingWeb',
      name: 'loginWelcomeText',
      desc: '',
      args: [],
    );
  }

  String get loginLoadEvents {
    return Intl.message(
      'Loading events...',
      name: 'loginLoadEvents',
      desc: '',
      args: [],
    );
  }

  String get loginButton {
    return Intl.message(
      'Log in',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  String get logoutButton {
    return Intl.message(
      'Log out',
      name: 'logoutButton',
      desc: '',
      args: [],
    );
  }

  String get startListening {
    return Intl.message(
      'Start listening',
      name: 'startListening',
      desc: '',
      args: [],
    );
  }

  String get stopListening {
    return Intl.message(
      'Stop listening',
      name: 'stopListening',
      desc: '',
      args: [],
    );
  }

  String get latitudeLongitude {
    return Intl.message(
      'Lat: \$lat, Long: \$long',
      name: 'latitudeLongitude',
      desc: '',
      args: [],
    );
  }

  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
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