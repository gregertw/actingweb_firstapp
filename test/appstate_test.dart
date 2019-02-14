import 'package:flutter_test/flutter_test.dart';
import 'package:first_app/models/appstate.dart';

// This test can be extended as we get more appstate
// The auth_provider_test tests the authentication appstate,
// so this is a duplication for illustration purposes.
void main() {
  AppStateModel state;
  setUp(() async {
    state = AppStateModel();
  });
  test('not logged in', () {
    expect(state.authenticated, false);
  });
}