# first_app: Starter app for a Flutter production app

**Maintainer**: Greger Wedel, <https://github.com/gregertw>

Listed on: [![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)

**Latest build and artifacts**: [![Codemagic build status](https://api.codemagic.io/apps/5e23f3b4c5faa6a356815277/5e23f3b4c5faa6a356815276/status_badge.svg)](https://codemagic.io/apps/5e23f3b4c5faa6a356815277/5e23f3b4c5faa6a356815276/latest_build)

**Latest update:** Support for Flutter 3.0.1

There are lots of simple Flutter app examples out there, but very few show how to tie together the elements
you need to put an app into production. In my process of evaluating Flutter maturity and readiness for
production apps, I started to put together the various elements into a single app. It evolved over time to
a starter app (and template on Github) that has been updated and following best practices and sound engineering
practices.

The focus of this starter app is thus not on the UI or functionality, but rather to show how a set of typical
app functionalities can be developed and supported in a sound code structure. The app structure has also been
designed to support a development team through separation of concerns and sound abstractions, as well as support
for all layers of testing (unit, widget, and integration).

This app has the following elements:

- Support for iOS, Android, and web
- Separation of business logic in models and providers, and UI in a separate folder structure
- Use of provider for app state management
- Authentication and authorization using OAuth2
- State management of login and login token including permanent storage for restarts
- Simple widget framework for handling logged-in, expired, and logged-out states
- Basic UI with sliding drawer menu and menu options
- Testing using unit test framework and mocking
- Integration tests
- Localization using i18n and the built-in Flutter support for generating boilerplate
- Use of a global UI theme
- Custom icons for both iOS and Android
- Use of Firebase Analytics for usage tracking
- Use of Firebase Crashlytics for crash reporting
- Use of Firebase Cloud Messaging for push notifications
- Use of a OS native capability (location tracking) using a published plugin (geolocator)
- Use of Google Maps to present a map of the current location
- Use of an independently defined new widget type called AnchoredOverlay to overlay a map widget

Here is a blog post about the value of using a starter app: <https://stuff.greger.io/2021/08/why-and-how-you-should-use-a-flutter-starter-app.html>

Also, see my blog post for a more detailed introduction to the various features: <https://stuff.greger.io/2019/07/production-quality-flutter-starter-app.html>.

## Known issues

- firebase_crashlytics does not support web

## Suggested improvements

I'm happy to accept pull requests for any improvements that will make this starter app even more complete from
a production app point of view. Here are some possible improvements:

- How to use Oauth2 to grant access to a service like Firebase database (very close now with Google login)
- How to do A/B testing
- How to use deep links
- ...

## CHANGELOG

See CHANGELOG.md

## QUICKSTART

The easiest way to get started with this app is to get it running in your own browser locally. To do that, you need to
configure a Google OAuth2 application at <https://console.cloud.google.com/apis/credentials>. You need to define
your own application so you can use Google to log in, and you need to make sure that the app knows about the URL it is
running from (i.e. localhost:port), so that it can present the URL to Google and the Google app is configured with the
same URL as an allowed redirect URL. In addition, the app needs to present the secret for the Google app you have configured.
If there is a mismatch in the URL your app is running under, what is configured in the app, and what is configured for the
Google app, the login process will fail.

Here are the steps:

- Go to Google console as above and create a new OAuth client ID. Choose Web Application as type.
- Add an Authorized redirect URI to <http://localhost:50000/>
- Copy the client id and update `clientIdGoogleApp` in lib/environment.dart
- Copy the client secret and `secretGoogleWeb`in the same file
- Start debugging with: `flutter run --debug --web-port=50000` (this will allow the app to present the right redirect URL)

In Visual Studio Code, you can add an entry to launch.json in .vscode:

```json
{
            "name": "Flutter: Debug web",
            "type": "dart",
            "request": "launch",
            "args": [
                "--web-port=50000"
            ],
            "flutterMode": "debug",
            "program": "lib/main.dart"
        },
```

## How to get started

The app uses a Google Firebase project (though this  is not a requirement if you drop analytics, messaging, and crashlytics).
The currently configured test project is available for your testing, but obviously you will not be able to log into these
projects, so the value of that is just that you can test the app without doing any code changes. To start tinkering, you
will want to create your own Firebase project.

But, first of all, check out the actingweb_firstapp code base (it's a template!). You can use any editor.

Make sure you have available a device to run the app on, either a physical device or an emulator, then just
run it on an emulator. You should be able to log into the app with your Google account (only on emulator, not web,
see later). Github is not supported for web, and requires a secret that Google does not require, so it will not work
until you register your own Github OAuth2 client.

lib/environment.dart contains the client values for Github and Google, here you can add your own client id and secrets
when you register your app for authentication with each of these.

See further below for introductions on specific areas of the app's functionality.

## Steps to make this your own app

Even if this app comes out of the box functionally working, you need to make it your own to build on it.
As a minimum, you need to do the following:

- Replace io.actingweb.firstapp with your own URI scheme/bundle id in android/, ios/, and lib/
- Replace firebase_options.dart with configurations for your own Firebase project, see
  <https://firebase.flutter.dev/docs/overview/>
- Edit lib/environment.dart with your own Google and Github client ids (or supply them in env variables)
- Supply environment variables for the secrets in environment.dart. In Visual Studio Code, you can edit your launch.json
  and add the "env": {} section
- You need to edit `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift` to update your API
  key for Google Maps (see <https://cloud.google.com/maps-platform/>)

That's all you need! The below sections give you more details on how each of the services have been integrated in the
code base.

## Integration pattern with various services

There are two integration needs in a Flutter app: integrate towards the underlying platform and integrating towards
the various external services you may want to use. Examples of the first is location, mobile messaging services (which
has support built into the iOS and Android platforms), persistence of data (i.e. shared_preferences), and registration
of  URI schemes for your application, so that your application can receive the authentication code necessary as part
of authentication.
The second category is how to use Google Firebase services (analytics,  messaging, and crash reports), authentication using
OAuth2 towards e.g. Github and Google, or Google Maps to show the map of where you are.

The most difficult is typically the integration towards the underlying platforms, but as Flutter has evolved with support
for web and matured on iOS and Android, more and more of integration necessary can be done in the Dart code and the platform
specific configuration has been reduced.

But still, you will need API keys or client ids or URLs for where to connect, and this must be configured somewhere. In
/lib/environment.dart you will find a class that pickes configuration variables from the environment (which can be set
in your CI/CD pipeline) and where you can set defaults. However, these can only be used in the Dart code, so where there
are needs for underlying platform integration (in ios, android, and web directories), you will have to go in and
edit the code and configs there directly. How is documented in the sections below.

## Support for Web

**NOTE!!** This is only for the web version of the app

To build the web version, use `flutter build web --base-href="/<some_path>/"` or use just `/`if you deploy to the root of
the domain. The web app should be deployed to `https://my.domain.com/some_path/`.

As of Flutter 2, web is supported on stable release, <https://flutter.dev/web> and a web version of app is available
at <https://gregertw.github.io/actingweb_firstapp_web>. The support for packagaes has increased, and most of the
functionality is now supported in the web version.

 See <https://flutter.dev/docs/get-started/web>. If you get errors, do `flutter clean`.

Firebase has now better web support as well, but there are two areas where you need to configure in the web/
folder: for Firebase messaging to work and for Google Maps.

For Google Maps, see <https://pub.dev/packages/google_maps_flutter_web>. You need an API key and add a script to
index.html.

Your Firebase project (google.com) must be configured with a web app (under General settings).
The config script snippet you get from setting up the web must replace the Firebase app config
in web/firebase-messaging-sw.js:

```js
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

If you have used the Firebase CLI tool to create a firebase_options.dart, you will find your Firebase web API key in
apiKey attribute. Add it also in lib/environment.dart (you don't need manual configuration in index.html anymore). This
is according to the documentation as it should be used in the getToken() method.

You can find all the details at <https://firebase.flutter.dev/docs/messaging/overview>, and you can find more details
on Firebase and messaging below.

The kIsWeb global variable is used to detect if the app is running on web and made available in appstate.dart
as a isWeb bool that can be used across the app. The variable is also used in appstate.dart to do the correct
Firebase Messaging initialisation.

If you are doing debugging of the app on web, use Google login, you need to edit environment.dart with the client id
and secret, and then (for local debugging) edit auth.dart and oauth.js with the localhost redirect URL with port number.
In addition, the Google web app (credentials) also need the ```http://localhost:<portnumber>/``` configured as a legal redirect URL. Configure Google web app at <https://console.cloud.google.com/apis/credentials>.

**Note on Github!** Github only supports clientid and secret, and does explicitly not support retrieving an access token
from a web applications (it is blocked with no CORS headers). This is because it is not considered safe. This means that
Github auth is disabled on web.

## Authentication and Authorization

### Evolution of auth in first_app

The authentication in first_app has been refactored three times. This last time, a package called oauth2_client has been
used as it has support for iOS, Android, and web. Previously, flutter_appauth was used, but the maintainer chose to stick
to the platforms where appauth.io library was supported, so it was not useful as a generic purpose auth library to demonstrate
support for auth also in browsers. Oauth2_client is missing Open ID Connect, a protocol based on OAuth2 that allows you to
uniquely identify a user logging in. With OAuth2, you need to call a non-standard user profile endpoint to retrieve profile
information. This is shown through how differently Github and Google support the user profile.

### About Authentication and Authorization

This app uses Github and Google as two alternative login flows. Once logged in, you can go to the drawer menu to retrieve user
information, as well as refresh the token and look at the details of the token and expiry.

Github supports only a variant of client credentials flow with
a clientid and a secret, which means that Github does not allow web-based login (as the secret will then be exposed in the
code loaded into the browser). However, Google supports both app authorization code exchange flow (use iOS for both iOS and
 Android), as well as a (non-standard) web flow with both clientid and secret, but where both the origin of the requests and
 the redirect URLs must be registered with the credentials.

To register new iOS and web app credentials for Google, go to <https://console.cloud.google.com/apis/credentials>.

To register an iOS/Android app for Github, go to <https://github.com/settings/developers>.

The auth.dart provider users oauth2_client to set up support for any number of identity providers. You should easily be
able to extend with Facebook and others. The AuthClient class can be extended to parse results after authentication and
retrieval of user profile. For how to use oauth2_client with other identity providers, see
<https://pub.dev/packages/oauth2_client>.

### Setup of auth

The oauth2_client package relies on flutter_web_auth to get a code that can be used to retrieve a token. This flow requires
that the mobile OS knows which application should pick up a return message, which is specified with the URI scheme aka your
app's bundle id. For first_app, this is io.actingweb.firstapp and callback must be registered in
android/app/src/main/AndroidManifest.xml. iOS does not additional config for handling the callback as long as the URI scheme
is the same as the bundle id.

To extend with new identity providers in AuthClient class, each OAuth2 client needs redirect URIs using the custom URI
scheme for mobile or the URI deployment location of the flutter app if on the web. Also, you need to configure scopes and
the user profile URL.
Also, each of the methods with logic based on the identity provider needs to be extended.

## Setup of Firebase Analytics

Go to <https://console.firebase.google.com> to add a project and set up Firebase for Flutter for your own app. The procedure
in its simplest form is to register the app identifier for iOS and Android (may be same or different, but it is recommended to
use the same as in this app). In the project, use Add App (+) and choose platform.

At <https://firebase.flutter.dev> the CLI tool is described. This is the simplest way to generatethe firebase_options.dart file,
or you can pull out the details for each app.

For Analytics, MaterialApp() in app.dart has this extra code to record navigation from screen to screen:

```dart
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
```

However, if you want to customize the names of the screens in the analytics reports, you should set the screen
name and class explicitly in each widget using:

```dart
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

For iOS, you also need to generate a key and upload that to Firebase, see <https://firebase.flutter.dev/docs/messaging/overview/>.

**Note!!** This app can receive notifications while in the background or terminated through the onMessage() and
onBackgroundMessage() events (in appstate.date). You should only use so-called "notification" messages and not "data" messages
for this (though you can have extra key/value pairs in the "data" section). For both Android and iOS, the notification will appear in the system tray and the app is launched.

**Note2!!** It is also possible to make the app react directly from the background to
 notifications. However, this requires custom logic for Android and iOS and is not straightforward, so be warned. There was also
  a bug related to background handling: <https://github.com/FirebaseExtended/flutterfire/issues/1763> This is now
fixed, but I have not prioritised trying to make it work.

**Note3!!** The iOS simulator does not support background notifications, a real device is needed.

The app will write the FCM token to console, but you can also go into the drawer menu and click on the menu header area
displaying name and email to view all details, including the Firebase messaging token.

The notification console to send a notification (once configured) is a bit tricky to find, but has this URL:
 ```https://console.firebase.google.com/u/0/project/<your_project>/notification/compose```. In the drawer menu, there is a menu
 option to show the last notification received. Only the title and body is shown.

Or you can use the command line. In order to send a notification, you need to construct a payload like this (this is for
shell and you need to replace the `<token>` with the app's token):

```bash
export DATA='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "<token>"}'
```

The "notification" part will be delivered either to system tray (background or not running) or directly if the app is open.
The click_action is required for Android only and for background notifications to work (i.e. it will not have an impact when
the Android app is in the foreground). For iOS, the extra click_action will be included, but does no harm.

The "id" and "status" elements in "data" are just example data payload that can be used by the app. Here you can send a URL
or any other data.

**Note** On iOS, these keys will appear on the root level of the message json and not within the "data" element.

To send the above payload, you can use curl:

```bash
curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=<key>"
```

Here `<key>` must be replaced with the Firebase Cloud Messaging API server key (found in the Settings of the Firebase app
under Cloud Messaging).

**So, in sum: Use "notification" to send a title and a message and the "data" element to send extra data. Except that all the "data" elements will appear on the root level of the message json in iOS, the behaviour will be similar for both Android and iOS.**

**Note, advanced!!** Read this if you want to use another flutter plugin for notifications (for further customisations etc).
You may then need to turn off so-called method swizzling for iOS on to allow other notification plugins. You then need to notify
FCM about reception of the message yourself ( see <https://firebase.google.com/docs/cloud-messaging/ios/receive>).

This is how you set swizzling off (in Info.plist):

```xml
 <key>FirebaseAppDelegateProxyEnabled</key>
 <false/>
```

## Set up Google Maps

A new AnchoredOverlay widget type has been added in `lib/ui/widgets/anchored_overlay.dart` to overlay a Google
map with current location and to add a button to toggle the overlay.
You need to edit `android/app/src/main/AndroidManifest.xml`, `ios/Runner/AppDelegate.swift`, and `web/ìndex.html` to update
your API key for Google Maps (see <https://cloud.google.com/maps-platform/>).

**IMPORTANT!!!! The keys being used are under a very low daily quota and has been added to git to make sure this app
runs out of the box. PLEASE change this as soon as possible and before you do your own development!**

A new map UI page has been added to lib/ui/pages, and the OverlayMapPage() widget is loaded in
lib/ui/pages/index.dart:

```dart
children: <Widget>[
            LocationStreamWidget(),
            OverlayMapPage(),
          ],
```

You can remove the overlay simply by removing the widget reference here. The OverlayMapPage widget relies on
the locstate to pick up the location.

## Tests

Testing is important in all production applications. This application includes unit testing (in the test/ folder),
widget testing (same folder) with mocks using mockito, and integration testing (with flutter_driver).

To run the unit and widget tests, run `flutter test`.

### Integration Tests - As of Flutter 2

As part of Flutter 2 releases, the integration testing support moved into the SDK. The approach to testing also
changed. Previously, there were two separate processes (see below) where you had to communicate between the process
running the tests outside and the actual app running on a device (emulated or physical). There is now more fully
integrated support. See <https://flutter.dev/docs/testing/integration-tests> for more details.

To run the integration tests, start the emulator or connect a device and run:
`flutter drive --driver test_driver/driver.dart --target integration_test/app_test.dart`

Currently, there is limited support for splitting up integration tests into separate files, so all tests should be
in the same file. However, you can use several testWidgets() calls. For demonstration purposes and due to the need
to log in, the current integration tests are all within the same testWidgets().

**This used to work, but support was removed when integration testing was changed. Not yet verified to work!**
You can also install chromedriver and run the tests in the browser. Make sure chromedriver is in your path and run:
`chromedriver --port=4444 &; flutter drive --driver test_driver/driver.dart --target integration_test/app_test.dart -d web-server`

### Mocking in Integration Tests

To simplify and make mocking dynamic, I have introduced mocks into the application state by adding a mocks object
to the state (see `model/appstate.dart`). The mocks object is a map of objects that can be used throughout the application
(i.e. dependency injection through app state). See in `integration_test/app_test.dart`
for an example where geolocation mock is enabled through setting mock: true. Note that care should be taken to avoid that
mocks can be triggered in the a production app as authentication can be bypassed this way.

## Some thoughts on state management

In investigating the various state management approaches, Brian Egan's <http://fluttersamples.com/> was very
helpful. I tried out a few approaches and in an early version of first_app ended up on scoped_model as an approach
that is intuitive, plays well with the Flutter principles of app design, and that is powerful enough to support a production app.
State management is a matter of taste, but I was trying to find the set of app architectural approaches that
fit with Flutter and that can support a bigger team of developers.

This choice turned out to be a pretty good one as the developer behind scoped_model also worked on the provider package
which in 2019 became the recommended way to provide widget trees with state updates. Provider is not entirely a
replacement of scoped_model, quoted from the provider home: "A mixture between dependency injection (DI) and
state management, built with widgets for widgets."
In the process of replacing scoped_model with provider, I chose not to add a more powerful state management
package (like MobX), but rather use simple classes with the ChangeNotifier mixin. This is all that is needed for
provider to pick up notifyListeners() calls. In a bigger application, you probably want to choose a state management
packaged like MobX to better handle more complex states.

The developer of provider has later developed <https://pub.dev/packages/flutter_riverpod>, which is a total rewrite
of state management (not using InheritedWidget). It is positioned as a "better" provider, however, I have chosen
not to rewrite the starter app with riverpod as provider is powerful enough for many real-life scenarios and the
current introduction to riverpod is harder to understand until you are deeper into Flutter. Also, there have been
introduced more state management packages and frameworks and choosing one that fits your project must be
evaluated on a case by case basis.
