import 'package:flutter/material.dart';
import 'package:first_app/models/appstate.dart';
import 'package:provider/provider.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/generated/i18n.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context, listen: false);
    final logo = Padding(
      padding: EdgeInsets.all(40.0),
      child: Image.asset('assets/actingweb-header-small.png'),
    );
    var welcomeText = S.of(context).loginWelcomeText;
    if (appState.authenticated) {
      welcomeText = S.of(context).loginLoadEvents;
    }
    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        welcomeText,
      ),
    );
    var body;
    if (appState.authenticated) {
      body = Column(
        children: [logo, welcome],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      body = Column(
        children: [logo, welcome, AuthPage()],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.grey, Theme.of(context).primaryColor]),
        ),
        child: body,
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  void auth(BuildContext context) {
    var auth0 = AuthClient(
        authClient: Provider.of<AppStateModel>(context, listen: false)
            .mocks
            .getMock('authClient'));
    auth0.authorize().then((res) {
      if (res.containsKey('access_token')) {
        Provider.of<AppStateModel>(context, listen: false).logIn(res);
        // Earlier, userinfo was retrieved here, but this failed as
        // when the future returned, the context could be null and thus
        // state could not be updated with user data.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          key: Key('LoginPage_LoginButton'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            auth(context);
          },
          padding: EdgeInsets.all(12),
          child: Text(S.of(context).loginButton),
        ),
      ),
    );
  }
}
