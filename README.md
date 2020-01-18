# first_app: Starter app for a Flutter production app

Maintainer: Greger Wedel, https://github.com/gregertw

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
- Use of a global UI theme
- Custom icons for both iOS and Android
- Use of Firebase Analytics for usage tracking
- Use of Firebase Crashlytics for crash reporting
- Use of a OS native capability (location tracking) using a published plugin (geolocator)
- Use of Google Maps to present a map of the current location
- Use of an independently defined new widget type called
  AnchoredOverlay to overlay a map widget

See my blog post for a more detailed introduction to the various features: https://stuff.greger.io/2019/07/production-quality-flutter-starter-app.html

## Suggested improvements

I'm happy to accept pull requests for any improvements that will make this starter app even more complete from
a production app point of view. Here are some possible improvements:

- Show how to send messages to the app
- How to use Oauth2 to grant access to a service like Firebase database
- How to set up a deployment pipeline with test app deployment
- How to do A/B testing
- How to use deep links

## CHANGELOG

See CHANGELOG.md

## How to get started

The app relies on an Auth0 project, as well as a Google Firebase project. The currently configured test 
projects are available for your testing, but obviously you will not be able to log into these projects, so
the value of that is just that you can test the app without doing any code changes. To start tinkering, you
will want to create your own Auth0 and Firebase projects.

But, first of all, check out the actingweb_firstapp code base. You can use any editor, but if you want to use the 
i18n generation, you need (at this point) Android Studio/IntelliJ as flutter_i18n is a plugin for this editor 
(Visual Studio Code support is in the works).

*NOTE!!!*
The plugin flutter_auth0 is expected in the directory above (../), so check out 
https://github.com/gregertw/flutter-auth0 there. This app is configured to use io.actingweb.firstapp as 
app identifier. You can use this identifier for
testing, but for your own app, you want to change this manually manually in ´android/app/build.gradle´ and 
´android/app/src/main/AndroidManifest.xml´ for Android. For iOS, you should change the product bundle identifier
 in XCode (TODO).

Also, in ´lib/providers/auth.dart´ you will find the instantiation of an auth0 object, this is where you change your
client id and domain used in Auth0 (see below for Auth0 setup). 

Make sure you have available a device to run the app on, either a physical device or an emulator, then just
start debugging. You should be able to log into the app with your Google account (note! your personal details
 will show up in the admin console of the ActingWeb Auth0 project).

## Set up Auth0

In Auth0, you need to configure a native app, add your allowed callback and logout URLs. The ones used for
this test project is: io.actingweb.firstApp://actingweb.eu.auth0.com/ios/io.actingweb.firstApp/callback, 
io.actingweb.firstApp://actingweb.eu.auth0.com/android/io.actingweb.firstApp/callback
As you can see, the callback URLs are based on the identifier + the Auth0 domain name of the project.

Beyond that, a default project should work. If you are not able to get a login window when clicking on the Login
button, try using the new Universal Login in Auth0.

## Set up Firebase Analytics

Go to https://firebase.google.com/docs/flutter/setup to set up Firebase for Flutter. The procedure in its
simplest form is to register the app identifier for iOS and Android (may be same or different, but is the 
same here) with Firebase using Add App. You will then drop into this project your own GoogleService-Info.plist 
and google-services.json files.

**Note!!** If you make a new project and don't just modify this, make sure you add GoogleService-Info.plist 
in Xcode (to Runner) as just dropping the file in will not work for iOS!

## Set up Google Maps (new Dec 26, 2019)

A new AnchoredOverlay widget type has been added in `lib/ui/widgets/anchored_overlay.dart` to overlay a Google 
map with current location and to add a button to toggle the overlay. 
You need to edit `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.m` to update your API key 
for Google Maps (see https://cloud.google.com/maps-platform/). 

**IMPORTANT!!!! The keys being used are under a very low daily quota and has been added to git to make sure the app
runs out of box. PLEASE change this as soon as possible and before you do your own development!**

The google_maps_flutter flugin relies on a preview functionality in iOS that needs to be turned on in info.plist 
(already added in this project) with:
```
  <key>io.flutter.embedded_views_preview</key>
  <true/>
```

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

NOTE! A Flutter bug will give you earlier logs, this can be confusing! 
https://github.com/flutter/flutter/issues/46815

You then run the integration tests using `export VM_SERVICE_URL=http://127.0.0.1:8888/;dart test_driver/app_test.dart`. 
You can change the tests (app_test.dart) and re-run without touching the app you test. Or you can change the app you 
test and do hot reload/restart. 

There is a .vscode/launch.json config that defines these and make them available from the command palette in Visual 
Studio Code (Tasks: Run test tasks). It should be easy to add keyboard shortcuts or add similar configs to your 
favourite IDE.

### Mocking in Integration Tests

In test_driver/app.dart, you will find dataHandler used by the enableFlutterDriverExtension() call. This allows
two-way communication between the tested application and the tests (that can send messages using 
driver.requestData('cmd')). This is an interesting technique to use to enable and disable mocks as you do the 
testing.

To simplify and make mocking dynamic, I have introduced mocks into the application state by adding a mocks object
to the state (see `model/appstate.dart`). The mocks object is a map of objects that can be used throughout the application (i.e. dependency injection through app state). See in ui/login/index.dart and the _AuthPageState class 
for an example with the Auth0Client.


## Some thoughts on state management

In investigating the various state management approaches, Brian Egan's http://fluttersamples.com/ was very 
helpful. I tried out a few approaches and initially ended up on scoped_model as an approach that is intuitive, 
plays well with the Flutter principles of app design, and that is powerful enough to support a production app.
State management is a matter of taste, but I was trying to find the set of app architectural approaches that
fit with Flutter and that can support a bigger team of developers.

This choice turned out to be a pretty good one as the team behind scoped_model also worked on the provider package
which in 2019 became the recommended way to provide widget trees with state updates. Provider is not entirely a 
replacement of scoped_model, quoted from the provider home: "A mixture between dependency injection (DI) and 
state management, built with widgets for widgets." 
In the process of replacing scoped_model with provider, I chose not to add a more powerful state management 
package (like MobX), but rather use simple classes with the ChangeNotifier mixin. This is all that is needed for 
provider to pick up notifyListeners() calls.
 