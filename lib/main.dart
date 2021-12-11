import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  // A breaking change in the platform messaging, as of Flutter 1.12.13+hotfix.5,
  // we need to explicitly initialise bindings to get access to the BinaryMessenger
  // This is needed by Crashlytics.
  // https://groups.google.com/forum/#!msg/flutter-announce/sHAL2fBtJ1Y/mGjrKH3dEwAJ
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  if (kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };
  } else {
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  // If we run on web, do not use Crashlytics (not supported on web yet)
  if (kIsWeb) {
    runApp(await getApp(web: true));
  } else {
    // Use dart zone to define Crashlytics as error handler for errors
    // that occur outside runApp
    runZonedGuarded<Future<void>>(() async {
      runApp(await getApp());
    }, FirebaseCrashlytics.instance.recordError);
  }
}
