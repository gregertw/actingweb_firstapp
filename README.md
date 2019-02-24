# first_app: Starter app for a Flutter production app

There are lots of simple Flutter app examples out there, but very few show hot to tie together the elements
you need to put an app into production.

This app has the following elements:

- Separation of business logic in models and providers, and UI in a separate folder structure
- Use of scoped_model for app state management
- State management of login and login token using Auth0 including permanent storage
- Use of a plugin that is not published (flutter_auth0)
- Simple widget framework for handling logged-in, expired, and logged-out states
- Testing using unit test framework and mocking
- Localization using i18n and the Android Studio/IntelliJ flutter i18n plugin to generate boilerplate
- (later) Testing of UI using widget tests
- Use of a global UI theme
- Custom icon for both iOS and Android
- Use of Firebase Analytics
- (later) Use of Firebase Crashlytics
- Use of a OS native capability (location tracking) using a published plugin (geolocator)
 
## Add Firebase Analytics

Go to https://firebase.google.com/docs/flutter/setup to set up Firebase for Flutter. The procedure in its
simplest form is to register the app identifier for iOS and Android (may be same or different, but is the same here)
with Firebase using Add App.

**Note!!** Make sure you add GoogleService-Info.plist in Xcode as just dropping the file in will not work for iOS!