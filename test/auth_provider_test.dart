import 'package:test/test.dart';
import 'package:first_app/providers/auth.dart';

void main() async {
  // We need a mock client to return the values that Auth0 would return
  var mockClient = MockOAuth2Client(redirectUri: '', customUriScheme: '');
  late AuthClient c;

  setUp(() async {
    c = AuthClient(clientSecret: '', authProvider: mockClient);
  });

  test('initially not logged in', () async {
    expect(c.isExpired, true);
    expect(c.isValid, false);
    expect(c.accessToken.isEmpty, true);
    expect(c.refreshToken.isEmpty, true);
    expect(c.shouldRefresh, false);
  });

  test('authenticate', () async {
    // Do the authorization that normally brings up the login window that leads
    // to a callback from Appauth and finally to the log in information (that
    // we mocked above)
    var res = await c.authorizeOrRefresh();
    expect(res, true);
    expect(c.isExpired, false);
    expect(c.isValid, true);
    expect(c.accessToken.isNotEmpty, true);
    expect(c.refreshToken.isNotEmpty, true);
    expect(c.shouldRefresh, false);
  });

  test('toJson', () async {
    var res = await c.authorizeOrRefresh();
    expect(res, true);
    var m = c.toJson();
    expect(m['accessToken'], 'an_access_token');
    expect(m['refreshToken'], 'a_refresh_token');
    var diff = DateTime.parse(m['expires'])
        .difference(DateTime.now().add(const Duration(seconds: 3600)));
    expect(diff.inSeconds, lessThan(1));
  });

  test('fromJson', () async {
    var m = {
      'accessToken': 'an_access_token',
      'refreshToken': 'a_refresh_token',
      'idToken': 'an_id_token',
      'expires':
          DateTime.now().add(const Duration(seconds: 3600)).toIso8601String()
    };
    c.fromJson(m);
    expect(c.accessToken, 'an_access_token');
    expect(c.refreshToken, 'a_refresh_token');
    expect(c.idToken, 'an_id_token');
    var diff =
        c.expires.difference(DateTime.now().add(const Duration(seconds: 3600)));
    expect(diff.inSeconds, 0);
  });

  test('fromJsonToStringFromString', () async {
    var exp =
        DateTime.now().add(const Duration(seconds: 3600)).toIso8601String();
    var m = {
      'accessToken': 'an_access_token',
      'refreshToken': 'a_refresh_token',
      'idToken': 'an_id_token',
      'expires': exp
    };
    c.fromJson(m);
    var c2 = AuthClient(clientSecret: '', authProvider: mockClient);
    c2.fromString(c.toString());
    expect(c2.accessToken, 'an_access_token');
    expect(c2.refreshToken, 'a_refresh_token');
    expect(c2.idToken, 'an_id_token');
    var diff = c.expires.difference(DateTime.parse(exp));
    expect(diff.inSeconds, 0);
  });

  test('closeSessions', () async {
    // Do the authorization that normally brings up the login window that leads
    // to a callback from Appauth and finally to the log in information (that
    // we mocked above)
    var res = await c.authorizeOrRefresh();
    expect(res, true);
    expect(c.isExpired, false);
    expect(c.isValid, true);
    c.closeSessions();
    expect(c.isExpired, true);
    expect(c.isValid, false);
    expect(c.accessToken.isEmpty, true);
  });
}
