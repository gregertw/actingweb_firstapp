import 'package:test/test.dart';
import 'package:first_app/models/appstate.dart';

void main() {
  AppStateModel state;
  setUp(() async {
    state = AppStateModel();
  });
  test('not logged in', () {
    expect(state.authenticated, false);
  });
}