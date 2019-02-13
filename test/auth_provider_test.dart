import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:first_app/models/appstate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/providers/auth.dart';
import 'package:flutter_auth0/flutter_auth0.dart';

// Create a class that mocks the auth0 library class
class MockAuth extends Mock implements WebAuth {}

void main() {

  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  // This is to keep our appstate
  AppStateModel appState = AppStateModel();

  // We need a mock client to return the values that Auth0 would return
  var mockClient = MockAuth();
  // Stub authorize()
  when(mockClient.authorize(audience: anyNamed('audience'), scope: anyNamed('scope')))
      .thenAnswer((_) => Future.value({
    'access_token': 'an_access_token'
  }));

  test('initially not logged in', () {
    expect(appState.authenticated, false);
  });

  test('authenticate', () async {
    // Let's create an Auth0 provider with our appstate and request it
    // to use our mock version of Auth0 lib
    var c = Auth0Client(appState, authClient:mockClient);
    // Do the authorization that normally brings up the login window that leads
    // to a callback from Auth0 and finally to the log in information (that
    // we mocked above)
    var res = await c.authorize();
    expect(res, true);
    expect(appState.authenticated, true);
    expect(appState.userToken, 'an_access_token');
  });

  test('log out', () {
    appState.logOut();
    expect(appState.authenticated, false);
  });

}
