// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("ActingWeb First App"),
    "clickToView" : MessageLookupByLibrary.simpleMessage("Click to view..."),
    "drawerButtomSheetExpires" : MessageLookupByLibrary.simpleMessage("Expires"),
    "drawerButtomSheetFCMToken" : MessageLookupByLibrary.simpleMessage("Firebase messaging token"),
    "drawerButtomSheetIdToken" : MessageLookupByLibrary.simpleMessage("Id token"),
    "drawerButtomSheetUserToken" : MessageLookupByLibrary.simpleMessage("User token"),
    "drawerEmail" : MessageLookupByLibrary.simpleMessage("testuser@demoserver.io"),
    "drawerEmptyEmail" : MessageLookupByLibrary.simpleMessage(""),
    "drawerEmptyName" : MessageLookupByLibrary.simpleMessage("N/A"),
    "drawerGetUserInfo" : MessageLookupByLibrary.simpleMessage("Get user info"),
    "drawerGetUserInfoFailedMsg" : MessageLookupByLibrary.simpleMessage("Try to refresh token first!"),
    "drawerGetUserInfoFailedTitle" : MessageLookupByLibrary.simpleMessage("User info retrieval failed"),
    "drawerGetUserInfoResultMsg" : MessageLookupByLibrary.simpleMessage("User details have been updated."),
    "drawerGetUserInfoResultTitle" : MessageLookupByLibrary.simpleMessage("User info retrieved"),
    "drawerHeaderInitialEmail" : MessageLookupByLibrary.simpleMessage("..."),
    "drawerHeaderInitialName" : MessageLookupByLibrary.simpleMessage("Click to view details..."),
    "drawerLocalisation" : MessageLookupByLibrary.simpleMessage("Current localisation"),
    "drawerLocalisationResultMsg" : MessageLookupByLibrary.simpleMessage("Changed to "),
    "drawerLocalisationResultTitle" : MessageLookupByLibrary.simpleMessage("Locale changed"),
    "drawerRefreshTokens" : MessageLookupByLibrary.simpleMessage("Refresh tokens"),
    "drawerRefreshTokensResultMsg" : MessageLookupByLibrary.simpleMessage("See user details for the new tokens."),
    "drawerRefreshTokensResultTitle" : MessageLookupByLibrary.simpleMessage("Tokens refreshed"),
    "drawerUser" : MessageLookupByLibrary.simpleMessage("Test User"),
    "latitudeLongitude" : MessageLookupByLibrary.simpleMessage("Lat: \$lat, Long: \$long"),
    "loginButton" : MessageLookupByLibrary.simpleMessage("Log in"),
    "loginLoadEvents" : MessageLookupByLibrary.simpleMessage("Loading events..."),
    "loginWelcomeText" : MessageLookupByLibrary.simpleMessage("Welcome to ActingWeb"),
    "logoutButton" : MessageLookupByLibrary.simpleMessage("Log out"),
    "okButton" : MessageLookupByLibrary.simpleMessage("Ok"),
    "startListening" : MessageLookupByLibrary.simpleMessage("Start listening"),
    "stopListening" : MessageLookupByLibrary.simpleMessage("Stop listening"),
    "unknown" : MessageLookupByLibrary.simpleMessage("Unknown")
  };
}
