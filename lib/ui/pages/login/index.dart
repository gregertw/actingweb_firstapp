import 'package:flutter/material.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/providers/auth.dart';
import 'package:first_app/generated/i18n.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = AppStateModel.of(context, true);
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
        style: TextStyle(fontSize: 24.0, color: Colors.white),
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
          gradient: LinearGradient(colors: [
            Colors.grey,
            Colors.lightBlueAccent,
          ]),
        ),
        child: body,
      ),
    );
  }
}


class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();

}

class _AuthPageState extends State<AuthPage> {

  void auth() {
    new Auth0Client().authorize().then((res) {
      if (res.containsKey('access_token')) {
        AppStateModel.of(context, true).logIn(res);
        Navigator.pushReplacementNamed(context, "/HomePage");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            auth();
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueAccent,
          child: Text(S.of(context).loginButton, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}