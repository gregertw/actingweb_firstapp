# CHANGELOG


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

- Remove flutter_auth0 and thus Auth0 support and replace with flutter_appauth (https://appauth.io) and use a demo identityserver
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
- Fix breaking change issue, ref https://groups.google.com/forum/#!msg/flutter-announce/sHAL2fBtJ1Y/mGjrKH3dEwAJ
- Move to SDK version target 29 (from 28)
- Add Podfile to version control
- Move from flutter_crashlytics to firebase_crashlytics (official plugin)

