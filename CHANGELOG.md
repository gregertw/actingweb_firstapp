# CHANGELOG

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

