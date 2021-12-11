import 'package:test/test.dart';
import 'package:first_app/models/appstate.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This test can be extended as we get more appstate

void main() async {
  late AppStateModel state;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  var prefs = await SharedPreferences.getInstance();

  setUp(() async {
    // We need mock initial values for SharedPreferences
    SharedPreferences.setMockInitialValues({});
    state = AppStateModel(prefs: prefs, mock: true);
  });
  test('not logged in', () async {
    expect(state.authenticated, false);
  });
  test('log in - log out', () async {
    await state.authorize();
    expect(state.authenticated, true);
    expect(state.userToken, 'an_access_token');
    state.logOut();
    expect(state.authenticated, false);
  });
}
