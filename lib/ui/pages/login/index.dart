import 'package:flutter/material.dart';
import 'package:first_app/models/appstate.dart';
import 'package:provider/provider.dart';
import 'package:first_app/l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [logo, welcome],
      );
    } else {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [logo, welcome, const AuthPage()],
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
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: 150.0,
      constraints: const BoxConstraints(maxHeight: 200.0, maxWidth: 150.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListView(children: <Widget>[
          !Provider.of<AppStateModel>(context, listen: false).isWeb
              ? ElevatedButton(
                  key: const Key('LoginPage_LoginButton_Github'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {
                    Provider.of<AppStateModel>(context, listen: false)
                        .authorize('github');
                  },
                  child: Text(AppLocalizations.of(context)!.loginButton_Github),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {},
                  child: const Text('Github N/A'),
                ),
          ElevatedButton(
            key: const Key('LoginPage_LoginButton_Google'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Provider.of<AppStateModel>(context, listen: false)
                  .authorize('google');
            },
            child: Text(AppLocalizations.of(context)!.loginButton_Google),
          ),
        ]),
      ),
    );
  }
}
