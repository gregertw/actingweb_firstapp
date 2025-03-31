# CHANGELOG

## Mar 31, 2025

- Upgrade to Flutter 3.29.2
- Upgrade packages
- Bump version to 1.6.14+34

## Jan 27, 2024

- Upgrade to Flutter 3.16.9
- Upgrade packages
- Bump version to 1.6.13+33

## Dev 31, 2023

- Upgrade to Fluter 3.16.5
- Upgrade packages
- Bump version to 1.6.12+32

## Dec 9, 2023

- Upgrade to Flutter 3.16.3
- Bump version to 1.6.11+31

## Nov 26, 2023

- Fixed issues with compliance with Google Play and Apple AppStore
- Further package upgrades
- Bump to 1.6.10+29

## Nov 19, 2023

- Validate for Flutter 3.16.0
- Upgrade all packages
- Bump versionn to 1.6.10+28

## May 18, 2023

- Validate for Flutter 3.10.1
- Upgrade all packages
- Bump version to 1.6.9+27

## Dec 27, 2022

- Validate for Flutter 3.3.10
- Upgrade all packages
- Fixed a bug with flutter_web_auth in AndroidManifest.xml
- Bump version to 1.6.9+26

## Oct 8, 2022

- Validate for Flutter 3.3.4
- Upgrade package dependencies
- Get rid of dependency on unofficial flutter_web_auth (new ouath2_client version)
- Bump version to 1.6.8+24
- Move from jcenter to mavenCentral

## July 20, 2022

- Validate for Flutter 3.0.5
- Upgrade package dependencies
- Major version firebase_messaging => adjusted README
- flutter_web_auth (dependency for oauth2_client) seems to be lacking care, adding tmp dependency override
- Major version upgrade of geolocator requires Android SDK 33, bumped the version
- Fix #44, use of flutter_geocoding results in web console error
- Bump version to 1.6.7+22

## June 22, 2022

- Emergency fix for android redirect (in AndroidManifest.xml)
- Fix redirect URL for Github app
- Bump version to 1.6.5+20, had to dump to 1.6.6+21 due to a CI/CD issue

## June 17, 2022

- Validate for Flutter 3.0.2
- Upgrade packages
- Fix bug in Google app redirect
- Bump version to 1.6.4+19

## May 29, 2022

- Validate for Flutter 3.0.1
- Upgrade packages
- Add redirect URLs to environment variables, so everything can be set in environment.dart
- Refactor auth.dart and oauth.js to use current URL for web support without explicit configuration
- Update with a quickstart for Google login, fixing [#39](https://github.com/gregertw/actingweb_firstapp/issues/39)
- Bump version to 1.6.3+18

## Feb 18, 2022

- Validate for Flutter 2.10.1
- Upgrade packages
- Bump version to 1.6.2+17

## Dec 23, 2021

- Fix bug with lost request for permissions
- Factored out Geo() as a provider
- Bumped version to 1.6.1+16

## Dec 22, 2021

- Add a CustomDialog to inform about location not available for the app

## Dec 19, 2021

- Add drawer menu with display of latest Firebase FCM notification

## ## Dec 12, 2021

- Reinstated Android and iOS manual config to make Crashlytics work
- Factored out OAuth2 clientId and secret to use environment variables
- Added Google auth as an alternative
- Refactored auth provider to more easily support multiple identity providers
- Removed the mocking through mockmap.dart to only use provider = 'mock' in AuthClient
- Introduced environment.dart with class Environment to support secrets in env vars in CI/CD

## Dec 10, 2021

- Full refactoring of auth, remove flutter_appauth and switch to oauth2_client
- Upgrade all packages
- Support flutter 2.8.0 release
- Change firebase intialisation to pure dart with firebase_options.dart file
  (delete google-services.json and GoogleService-Info.plist)
- Remove Android and iOS specific Firebase init (don't report on native crashes anymore)
  see <https://firebase.flutter.dev/docs/crashlytics/overview/>
- Bump version to 1.6.0+15
- Fix bug in permission handling for iOS

## Nov 14, 2021

- Fix null bug in _markers in map overlay widget
- Support Xcode 13.2beta
- Switch over to using flutter test instead of flutter drive (.vscode/tasks.json)
- Bump targetSdkVersion to 31

## Oct 17, 2021

- Support latest flutter 2.5.3
- Minor upgrades of package dependencies
- Restructured MaterialApp and ChangeNotifierProvider to simplify appState as global state
- Refactored localizations (S.) to  use the new built-in generation
- Align with the flutter skeleton template
- Bump version to 1.5.0+14

## Sep 10, 2021

- Support for flutter 2.5.0
- Add exclude arm64 from simulator architecture to handle Xcode command line build failure
- Upgrade all packages
- Simplify theme
- Bump version to 1.4.4+13

## May 24, 2021

- Verified null safety and upgraded app to sdk: '>=2.12.0 <3.0.0'
- Updated integration tests to Flutter 2 SDK supported integration_tests
- Bump version to 1.4.3+11

## May 22, 2021

- Upgraded to flutter 2.2
- Updated all dependencies to the latest, except test (dependency on a very new library not used by others)
- All dependencies should now be upgraded to null safety
- Bumped version to 1.4.2+10

## Mar 11, 2021

- Add proguard rule to keep androidx.lifecycle.DefaultLifecycleObserver as it is pruned
  in release build and Maps fail

## Mar 7, 2021

- Added APN (push notifications) capability to the ios project
- Bump to 1.4.0 as Flutter2 support by mistake was released as 1.3.4

## Mar 7 , 2021

- Upgrade all dependencies and use of packages to flutter 1.25
- Add support for Google Maps for web
- Remove background access to location due to stricter Android policies
- Remove background notifications for iOS as its not used
- Clean up based on new firebase initialisation and plugin support
- Bump minSdkVersion to 21 due to requirements from various plugins
- Bump gradle and google-services version to 4.1.1 and 4.3.4 respectively
- Bump ios platform version to 10.0 in ios Podfile due to firebase requirements
- Upgrade to newest versions of all requirements (not null-safe)
- Refactored geolocation code to new split plugins and usage
- Refactored to new buttons (e.g. ElevatedButton and TextButton)
- Fix introduced issue in integration tests where flutter driver cannot start
  after flutter bindings have been initialised
- Refactor use of crashlytics as it does not support web
- Get rid of discontinued flushbar (use new standard snackbar)

## Oct 2, 2020

- Bump up to version 1.22 of Flutter SDK, XCode 12, and Android 4 w/ API level 30
- Bump up a number of packages and clean up iOS and Android build configs (simplified)
- Lock down mockito (newest version has hard dependency on null safefy in Dart)
- Add an explicit Apache-2 license
- Bump version to 1.3.3+7

## Aug 2, 2020

- Added support for web (for Flutter beta)
- Added generated_plugin_registrant.dart and AppDelegate.swift (unused)
  to be compatible flutter create . (which refreshed ios, android, and web folders)
- Bump version to 1.3.2+6, no functionality change for mobile apps, but minor fixes

## Jul 26, 2020

- Added support for Firebase messaging, including access to the token from the drawer menu
  (click on the user details in the header)
- Bump version to 1.3.1+5

## Jul 25, 2020

- Added a drawer menu, moved logout into menu, added menu options to refresh tokens and get user info, as well as to view
  user details
- Bump version to 1.3.0+4

## Jul 16, 2020

- Changed client id code for demo.identityserver.io as they have changed the codes they use

## Jun 14, 2020

- Remove flutter_auth0 and thus Auth0 support and replace with flutter_appauth (<https://appauth.io>) and use a demo identityserver
- Release version 1.2.0

## May 16, 2020

- Upgrade to latest Flutter 1.17.1 and tools

## Jan 20, 2020

- Replace local flutter-auth0 package with released package
- Fix ios build issues that caused Framework for App not found

## Jan 18, 2020

- Replace scoped_model with provider (scoped_model deprecated and provider is recommended)

## Jan 13, 2020

- Add test API keys for Google Maps to the git repo to make it run out of the box
  (yes, it has a daily, low quota)
- Fix flutter build apk issue that causes firebase_analytics to fail build
- Fix ios target configs < 8.0
- Add integration testing with flutter_driver

## Jan 5, 2020

- Use dart format and add commas to get recommended formatting for widgets

## Jan 1, 2019

- Add widget tests for all relevant widgets

## Dec 30, 2019

- Fix file import to use package import (more correct)
- Separate out change log from README into CHANGELOG.md

## Dec 26, 2019

- Add location (latitude, longitude) to global appstate
- Remove .flutter-plugins-dependencies from version control
- Fix firstApp -> firstapp in BUNDLE_ID for iOS
- Fix bug where attempt to store userinfo after logging in fails due to context being null and appstate
  cannot be found
- Add an overlay widget with Google Maps loading current location map

## Dec 22, 2019

- Clean up leftover comments
- Add a proper theme and use it consistently through the app

## Dec 16, 2019

- Use new flutter_i18n plugin for Android Studio/IntelliJ that supports only specifying language (and not
  requires both language and country) in .arb files

## Dec 15, 2019

- Upgrade to Flutter 1.12.14+hotfix.5
- Upgrade package dependencies to latest versions
- Fix breaking change issue, ref <https://groups.google.com/forum/#!msg/flutter-announce/sHAL2fBtJ1Y/mGjrKH3dEwAJ>
- Move to SDK version target 29 (from 28)
- Add Podfile to version control
- Move from flutter_crashlytics to firebase_crashlytics (official plugin)
