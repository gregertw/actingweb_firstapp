import 'package:flutter/material.dart';
import 'package:first_app/models/appstate.dart';
import 'package:provider/provider.dart';
import 'package:first_app/providers/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context, listen: false);
    final logo = Padding(
      padding: const EdgeInsets.all(40.0),
      child: Image.asset('assets/actingweb-header-small.png'),
    );
    var welcomeText = AppLocalizations.of(context)!.loginWelcomeText;
    if (appState.authenticated) {
      welcomeText = AppLocalizations.of(context)!.loginLoadEvents;
    }
    final welcome = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        welcomeText,
      ),
    );
    Column body;
    if (appState.authenticated) {
      body = Column(
        children: [logo, welcome],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    } else {
      body = Column(
        children: [logo, welcome, const AuthPage()],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(28.0),
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
  const AuthPage({Key? key}) : super(key: key);

  void auth(BuildContext context) {
    var auth0 = AuthClient(
        authClient: Provider.of<AppStateModel>(context, listen: false)
            .mocks
            .getAppAuth());
    try {
      auth0.authorize().then((res) {
        if (res.containsKey('access_token')) {
          Provider.of<AppStateModel>(context, listen: false).logIn(res);
          // Earlier, userinfo was retrieved here, but this failed as
          // when the future returned, the context could be null and thus
          // state could not be updated with user data.
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key('LoginPage_LoginButton'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(15),
        ),
        onPressed: () {
          auth(context);
        },
        child: Text(AppLocalizations.of(context)!.loginButton),
      ),
    );
  }
}
