import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/appstate.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This test can be extended as we get more appstate
// The auth_provider_test tests the authentication appstate,
// so this is a duplication for illustration purposes.
void main() {
  AppStateModel state;
  // We need mock initial values for SharedPreferences
  SharedPreferences.setMockInitialValues({});
  setUp(() async {
    var prefs = await SharedPreferences.getInstance();
    state = AppStateModel(prefs);
  });
  test('not logged in', () {
    expect(state.authenticated, false);
  });
}
