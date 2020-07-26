import 'package:test/test.dart';
import 'package:first_app/models/appstate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/mock/mock_appauth.dart';

void main() async {
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();
  // This is to keep our appstate
  // NOTE!! We here also test the appstate related to authentication
  AppStateModel appState = AppStateModel(prefs);

  // We need a mock client to return the values that Auth0 would return
  var mockClient = MockFlutterAppAuth();

  test('initially not logged in', () {
    expect(appState.authenticated, false);
  });

  test('authenticate', () async {
    // Let's create an Appauth provider with our appstate and request it
    // to use our mock version of Appauth lib
    var c = AuthClient(authClient: mockClient);
    // Do the authorization that normally brings up the login window that leads
    // to a callback from Appauth and finally to the log in information (that
    // we mocked above)
    var res = await c.authorize();
    appState.logIn(res);
    expect(res.containsKey('access_token'), true);
    expect(appState.authenticated, true);
    expect(appState.userToken, 'an_access_token');
  });

  test('log out', () {
    appState.logOut();
    expect(appState.authenticated, false);
  });
}
