# first_app: Starter app for a Flutter production app

**Maintainer**: Greger Wedel, https://github.com/gregertw

Listed on: 
<a href="https://github.com/Solido/awesome-flutter">
   <img alt="Awesome Flutter" src="https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square" />
</a>

**Latest build and artifacts**: [![Codemagic build status](https://api.codemagic.io/apps/5e23f3b4c5faa6a356815277/5e23f3b4c5faa6a356815276/status_badge.svg)](https://codemagic.io/apps/5e23f3b4c5faa6a356815277/5e23f3b4c5faa6a356815276/latest_build)

** Latest update: Support for Flutter 2 **

There are lots of simple Flutter app examples out there, but very few show how to tie together the elements
you need to put an app into production. In my process of evaluating Flutter maturity and readiness for
production apps, I started to put together the various elements into a single app. It evolved over time to 
a starter app (and template on Github) that has been updated and following best practices and sound engineering
practices.

The focus of this starter app is thus not on the UI or functionality, but rather to show how a set of typical
app functionalities can be developed and supported in a sound code structure. The app hstructure as also been 
designed to support a development team through separation of concerns and sound abstractions, as well as support
for all layers of testing (unit, widget, and integration).

This app has the following elements:

- Support for iOS, Android, and web
- Separation of business logic in models and providers, and UI in a separate folder structure
- Use of provider for app state management
- Authentication and authorization using the https://appauth.io/ OpenID Connect and OAuth2 library
- State management of login and login token including permanent storage for restarts
- Simple widget framework for handling logged-in, expired, and logged-out states
- Basic UI with sliding drawer menu and menu options
- Testing using unit test framework and mocking
- Localization using i18n and the Android Studio/IntelliJ flutter i18n plugin to generate boilerplate
- Use of a global UI theme
- Custom icons for both iOS and Android
- Use of Firebase Analytics for usage tracking
- Use of Firebase Crashlytics for crash reporting
- Use of Firebase Cloud Messaging for push notifications
- Use of a OS native capability (location tracking) using a published plugin (geolocator)
- Use of Google Maps to present a map of the current location
- Use of an independently defined new widget type called
  AnchoredOverlay to overlay a map widget

See my blog post for a more detailed introduction to the various features: https://stuff.greger.io/2019/07/production-quality-flutter-starter-app.html, also this update post explains the latest changes: https://stuff.greger.io/2020/01/production-quality-flutter-starter-app-take-two.html

## Known issues

- google_maps_flutter_web throws exceptions on updateTileOverlays() not implemented 
  (https://github.com/flutter/flutter/issues/76361). This has been fixed in a more recent
  version, but there is a dependency on a higher version of google_maps_flutter that breaks dependency requirements
  for firebase
- firebase_crashlytics does not support web
## Suggested improvements

I'm happy to accept pull requests for any improvements that will make this starter app even more complete from
a production app point of view. Here are some possible improvements:

- How to use Oauth2 to grant access to a service like Firebase database
- How to do A/B testing
- How to use deep links

## CHANGELOG

See CHANGELOG.md

## How to get started

The app uses a Google Firebase project. The currently configured test 
project is available for your testing, but obviously you will not be able to log into these projects, so
the value of that is just that you can test the app without doing any code changes. To start tinkering, you
will want to create your own Firebase project.

But, first of all, check out the actingweb_firstapp code base. You can use any editor, but if you want to use the 
i18n generation, you need (at this point) Android Studio/IntelliJ as flutter_i18n is a plugin for this editor 
or for Visual Studio Code.

Make sure you have available a device to run the app on, either a physical device or an emulator, then just
start debugging. You should be able to log into the app with the described demo accounts or your Google account.

## Support for Web

As of Flutter 2, web is supported on stable release, https://flutter.dev/web.

A web version of app is available at https://gregertw.github.io/actingweb_firstapp_web

The web version uses the mock system also used by the tests to bypass login (appauth is still not supported for
 Flutter web) and geo location (geolocator is not supported for Flutter web). Firebase Messaging is not fully supported 
 for web in Flutter yet, so the code can be found in web/index.html, which makes it a bit clumsy and not really 
 suited for a true "single code-base" project as you need to make the glue code yourself.

 See https://flutter.dev/docs/get-started/web. If you get errors, do `flutter clean`.

Also note that your Firebase project (google.com) must be configured with a web app (under General settings). 
The config script snippet you get from setting up the web must replace the Firebase app config in 
web/index.html and in web/firebase-messaging-sw.js:

```
  var firebaseConfig = {
    apiKey: "AIzaSyDjVjlcUKYUBb62x4K8WUGI47mXXlfKTtI",
    authDomain: "actingweb-firstapp.firebaseapp.com",
    databaseURL: "https://actingweb-firstapp.firebaseio.com",
    projectId: "actingweb-firstapp",
    storageBucket: "actingweb-firstapp.appspot.com",
    messagingSenderId: "748007732162",
    appId: "1:748007732162:web:ff42373829ce3137785c5b",
    measurementId: "G-M7F2YR6FNW"
  };
```

You then need to generate the key pair for the Firebase web app and copy the public key to web/index.html here:

```
// This is the public key from the Firebase web app config
  messaging.usePublicVapidKey("<your pibluc key here>");
```

You can find all the details at https://firebase.google.com/docs/cloud-messaging/js/client#configure_web_credentials_in_your_app

The kIsWeb global variable is used to detect if the app is running on web and mocks are used. Please note
that this should not be done for a production app as authentication is bypassed. The variable is also used in
appstate.dart to do the correct Firebase Messaging initialisation.

When you start up the web app, you will be requested for permissions to receive notifications. **To see the Firebase
messaging token to use when sending a message and the incoming message when the tab is in the front, you need to look
at the Chrome developer console, not the Flutter console.** Background messages (when the tab is in the backgroun),
will pop up as a browser notification. There is currently no code to handle tokens and messages as this currently
needs to be done in Javascript and not really integrated in the Flutter code base.

## Authentication and Authorization

### About Authentication and Authorization

This app uses a demo Identiy Provider (IdP) server for authentication. The library appauth (https://appauth.io) and its Flutter plugin flutter_appauth adds OpenID Connect support to the app and can easily be adapted to your needs or replaced
by another library/authentication method. 

The demo.identityserver.io IdP service is used as the authorization server and as a test example as an API gateway. 
See https://medium.com/@darutk/diagrams-of-all-the-openid-connect-flows-6968e3990660  
(example #1 with response_type=code and openid included in the scope) for a visual overview of the flow used. 

The OAuth2 authorization flow is used, and the appauth library function authorizeAndExchangeCode() is used to do both the login at demo.identiyserver.io to get the code, and then exchange the code for both an id token and an access token from the token endpoint on the demo.identiyserver.io server. Finally, the getUserInfo() function in auth.dart (lib/providers/) uses a test API endpoint with the access token to retrieve information about the logged in user.

If your app is just using Google APIs and only accepts Google logins, you could replace the IdP with Google directly and end up with an access token to access Google APIs on behalf of the user's account. See how at https://github.com/openid/AppAuth-Android/blob/master/app/README-Google.md

To learn more about how the appauth library, this is a good reference: https://github.com/openid/AppAuth-Android/tree/master/app

### Setup of Appauth

The appauth plugin is documented at https://pub.dev/packages/flutter_appauth. The Android and iOS setups are fairly simple. In build.gradle (android/) and Info.plist (ios/Runner/), you need to register the custom URL for your app (here: io.actingweb.firstapp). You should then use the same custom URL scheme in the redirectURL used in the AuthClient (see lib/provisers/auth.dart). (A custom URL is a URL that you register on the mobile device as a URL that will open up your app.)

The custom URL scheme is used in the request to the IdP server as the redirect URL after successful authentication (and since there are more scopes specified as default, successful authorization to those scopes). The login happens in the mobile's browser and the IdP will redirect the browser to this custom scheme, which again will open up the Flutter app. This allows the app the process the redirect, which includes a code (and more). Finally, these details are used to connect to the token endpoint to get the access token and id token.

### A Comment on Auth0 (old authn/authz)

This project previously used Auth0. Early on, an unpublished flutter_auth0 library was the only way to get proper social login support and was also a good example of including unpublished library code. The flutter_auth0 plugin was eventually published, but the Auth0 company did not show any interest in enabling the Flutter community. Although the flutter_auth0 plugin worked well, a single developer supported library is always risky and given that the intention of this starter app is to show choices that a professional developer team would make, flutter_auth0 was never really the right choice. After tinkering with adding device messaging using Firebase, I discovered a conflict between flutter_auth0 and Firebase Messaging pretty deep in native Android. I thus decided to replace Auth0 with something that could show a more robust implementation pattern and better support a professional development team.

## Setup of Firebase Analytics

Go to https://firebase.google.com/docs/flutter/setup to set up Firebase for Flutter for your own app. The procedure in its
simplest form is to register the app identifier for iOS and Android (may be same or different, but is the 
same in this app) with Firebase using Add App. You will then drop into this project your own GoogleService-Info.plist 
and google-services.json files.

**Note!!** If you make a new project and don't just modify this project, make sure you add GoogleService-Info.plist 
in Xcode (to Runner) as just dropping the file in will not work for iOS!

MaterialApp() has this extra code to record navigation from screen to screen:
```
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
```

However, if you want to customize the names of the screens in the analytics reports, you should set the screen 
name and class explicitly in each widget using:
```
await analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
```

NOTE!! Also, if you deploy to web, you need to update web/index.html and web/firebase-messaging-sw.js with the
Firebase web app config (see the web section).

## Setup of Firebase Cloud Messaging

This project also has set up Firebase Cloud Messaging, allowing you to send
push notifications to the app. You need to turn on Cloud Messaging in the Firebase Console.

For iOS, you also need to generate a key and upload that to Firebase, see https://pub.dev/packages/firebase_messaging.

**Note!!** This app can receive notifications while in the background or terminated through the onResume() and onLaunch() events. You should only use so-called "notification" messages and not "data" messages for this (though you can have extra key/value pairs in the "data" section). For both Android and iOS, the notification will appear in the system tray and the app is launched and onResume() or onLaunch() triggered. It is also possible to make app react directly from the background to notifications. However, this requires custom logic for Android and iOS and is not straightforward, so be warned. There was also a bug related to background handling: https://github.com/FirebaseExtended/flutterfire/issues/1763 This is now
fixed, but I have not prioritised trying to make it work.

**Note2!!** The iOS simulator does not support background notifications, only onResume() will be triggered.

The app will write the FCM token to console, but you can also go into the drawer menu and click on the menu header area displaying name and email to view all details, including the Firebase messaging token. 
In order to send a notification, you need to construct a payload like this (this is for shell and you need to replace the `<token>` with the app's token):
```
export DATA='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "<token>"}'
```

The "notification" part will be delivered either to system tray (background or not running) or directly if the app is open. The click_action is required for Android only and for onResume() and onLaunch() to work (i.e. will not have an impact when the Android app is in the foreground). For iOS, the extra click_action will be included, but does no harm.

The "id" and "status" elements in "data" are just example data payload that can be used by the app. Here you can send a URL or any other data. 

**Note** that on iOS, these keys will appear on the root level of the message json and not within the "data" element. 

To send the above payload, you can use curl:

```
curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=<key>"
```

Here `<key>` must be replaced with the Firebase Cloud Messaging API server key (found in the Settings of the Firebase app under Cloud Messaging).

**So, in sum: Use "notification" to send a title and a message and the "data" element to send extra data. Except that all the "data" elements will appear on the root level of the message json in iOS, the behaviour will be similar for both Android and iOS.**

**Note!!** Read this if you want to use another flutter plugin for notifications (for further customisations etc). You may then need to turn off so-called method swizzling for iOS on to allow other notification plugins. You then need to notify FCM about reception of the message yourself ( see https://firebase.google.com/docs/cloud-messaging/ios/receive). 

This is how you set swizzling off (in Info.plist):
```
	<key>FirebaseAppDelegateProxyEnabled</key>
	<false/>
```

## Set up Google Maps

A new AnchoredOverlay widget type has been added in `lib/ui/widgets/anchored_overlay.dart` to overlay a Google 
map with current location and to add a button to toggle the overlay. 
You need to edit `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.m` to update your API key 
for Google Maps (see https://cloud.google.com/maps-platform/). 

**IMPORTANT!!!! The keys being used are under a very low daily quota and has been added to git to make sure the app
runs out of box. PLEASE change this as soon as possible and before you do your own development!**

A new map UI page has been added to lib/ui/pages, and the OverlayMapPage() widget is loaded in 
lib/ui/pages/index.dart:

```
children: <Widget>[
            LocationStreamWidget(),
            OverlayMapPage(),
          ],
```

You can remove the overlay simply by removing the widget reference here. The OverlayMapPage widget relies on 
the appstate scoped_model to pick up the location, while the location is set from `lib/ui/location/index.dart`.

## Tests

Testing is important in all production applications. This application includes unit testing (in the test/ folder),
widget testing (same folder) with mocks using mockito, and integration testing (with flutter_driver).

To run the unit and widget tests, run `flutter test`. 

### Integration Tests

The integration tests run a real application on a device/simulator. This is done by having two processes: one 
instrumented application and one test process. You will find the instrumented app in `flutter_driver/app.dart` 
and the test app in `flutter/driver/app_test.dart`. The official introduction is found at 
https://flutter.dev/docs/cookbook/testing/integration/introduction

You can start an emulator and then run the integration tests with `flutter drive --target=test_driver/app.dart`.

The application is built and loaded onto the emulator and the tests are run, which takes a long time.

A better approach, especially if you are developing integration tests, is to run the two processes separately 
(thanks to https://medium.com/flutter-community/hot-reload-for-flutter-integration-tests-e0478b63bd54 for the hint).

First you run the observatory (the app to test), using 
`flutter run --host-vmservice-port 8888 --disable-service-auth-codes test_driver/app.dart`. Once it is up and 
running, you have an application you can hot reload ('r') or hot restart ('R'). 

You then run the integration tests using `export VM_SERVICE_URL=http://127.0.0.1:8888/;dart test_driver/app_test.dart`. 
You can change the tests (app_test.dart) and re-run without touching the app you test. Or you can change the app you 
test and do hot reload/restart. 

There is a .vscode/launch.json config that defines these and makes them available from the command palette in Visual 
Studio Code (Tasks: Run test tasks). It should be easy to add keyboard shortcuts or add similar configs to your 
favourite IDE.

### Mocking in Integration Tests

In test_driver/app.dart, you will find dataHandler used by the enableFlutterDriverExtension() call. This allows
two-way communication between the tested application and the tests (that can send messages using 
driver.requestData('cmd')). This is an interesting technique used to enable and disable mocks as you do the 
testing.

To simplify and make mocking dynamic, I have introduced mocks into the application state by adding a mocks object
to the state (see `model/appstate.dart`). The mocks object is a map of objects that can be used throughout the application (i.e. dependency injection through app state). See in ui/login/index.dart and the _AuthPageState class 
for an example with the Auth0Client. Note that care should be taken to avoid that mocks can be triggered in the a production
app as authentication can be bypassed this way.

## Some thoughts on state management

In investigating the various state management approaches, Brian Egan's http://fluttersamples.com/ was very 
helpful. I tried out a few approaches and initially ended up on scoped_model as an approach that is intuitive, 
plays well with the Flutter principles of app design, and that is powerful enough to support a production app.
State management is a matter of taste, but I was trying to find the set of app architectural approaches that
fit with Flutter and that can support a bigger team of developers.

This choice turned out to be a pretty good one as the developer behind scoped_model also worked on the provider package
which in 2019 became the recommended way to provide widget trees with state updates. Provider is not entirely a 
replacement of scoped_model, quoted from the provider home: "A mixture between dependency injection (DI) and 
state management, built with widgets for widgets." 
In the process of replacing scoped_model with provider, I chose not to add a more powerful state management 
package (like MobX), but rather use simple classes with the ChangeNotifier mixin. This is all that is needed for 
provider to pick up notifyListeners() calls. In a real application, you probably want to choose a state management 
packaged like MobX to better handle more complex states.

The developer of provider has later developer https://pub.dev/packages/flutter_riverpod, which is a total rewrite
of state management (not using InheritedWidget). It is positioned as a "better" provider, however, I have chosen
not to rewrite the starter app with riverpod as provider is powerful enough for many real-life scenarios and the
current introduction to riverpod is harder to understand until you are deeper into Flutter.