# first_app: Starter app for a Flutter production app

There are lots of simple Flutter app examples out there, but very few show how to tie together the elements
you need to put an app into production. In my process of evaluating Flutter maturity and readiness for
production apps, I started to put together the various elements into a single app. 

This app has the following elements:

- Separation of business logic in models and providers, and UI in a separate folder structure
- Use of scoped_model for app state management
- State management of login and login token using Auth0 including permanent storage for restarts
- Use of a plugin that is not published (flutter_auth0)
- Simple widget framework for handling logged-in, expired, and logged-out states
- Testing using unit test framework and mocking
- Localization using i18n and the Android Studio/IntelliJ flutter i18n plugin to generate boilerplate
- (later) Testing of UI using widget tests
- Use of a global UI theme
- Custom icons for both iOS and Android
- Use of Firebase Analytics for usage tracking
- Use of Firebase Crashlytics for crash reporting
- Use of a OS native capability (location tracking) using a published plugin (geolocator)
 
## How to get started

The app relies on an Auth0 project, as well as a Google Firebase project. The currently configured test 
projects are available for your testing, but obviously you will not be able to log into these projects, so
the value of that is just that you can test the app without doing any code changes. To start tinkering, you
will want to create your own Auth0 and Firebase projects.

But, first of all, check out the actingweb_firstapp code base. You can use any editor, but if you want to use the 
i18n generation, you need (at this point) Android Studio/IntelliJ as flutter_i18n is a plugin for this editor 
(Visual Studio Code support is in the works).

The plugin flutter_auth0 is expected in the directory above (../), so check out 
https://github.com/gregertw/flutter-auth0 there. This app is configured to use io.actingweb.firstapp as 
app identifier. You can use this identifier for
testing, but for your own app, you want to change this manually manually in android/app/build.gradle and 
android/app/src/main/AndroidManifest.xml for Android. For iOS, you should change the product bundle identifier
 in XCode (TODO).

Also, in lib/providers/auth.dart you will find the instantiation of an auth0 object, this is where you change your
client id and domain used in Auth0 (see below for Auth0 setup). 

Make sure you have available a device to run the app on, either a physical device or an emulator, then just
start debugging. You should be able to log into the app with your Google account (note! your personal details
 will show up in the admin console of the ActingWeb Auth0 project).

## Set up Auth0

In Auth0, you need to configure a native app, add your allowed callback and logout URLs. The ones used for
this test project is: io.actingweb.firstApp://actingweb.eu.auth0.com/ios/io.actingweb.firstApp/callback, io.actingweb.firstapp://actingweb.eu.auth0.com/android/io.actingweb.firstapp/callback
As you can see, the callback URLs are based on the identifier + the Auth0 domain name of the project.

Beyond that, a default project should work. If you are not able to get a login window when clicking on the Login
button, try using the new Universal Login in Auth0.

## Set up Firebase Analytics

Go to https://firebase.google.com/docs/flutter/setup to set up Firebase for Flutter. The procedure in its
simplest form is to register the app identifier for iOS and Android (may be same or different, but is the 
same here) with Firebase using Add App. You will then drop into this project your own GoogleService-Info.plist 
and google-services.json files.

**Note!!** If you make a new project and don't just modify this, make sure you add GoogleService-Info.plist 
in Xcode as just dropping the file in will not work for iOS!

## Some thoughts on state management

In investigating the various state management approaches, Brian Egan's http://fluttersamples.com/ was very 
helpful. I tried out a few approaches and ended up on scoped_model as an approach that is intuitive, plays well
with the Flutter principles of app design, and that is powerful enough to support a production app.

State management is a matter of taste, but I was trying to find the set of app architectural approaches that
fit with Flutter and that can support a bigger team of developers.