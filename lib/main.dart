import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';

final String clientId = 'PJVgy3Vh9jo7Wxl6sSUZsicE6S4TXZjB';
final String domain = 'actingweb.eu.auth0.com';

final Auth0 auth = new Auth0(clientId: clientId, domain: domain);
final WebAuth web = new WebAuth(clientId: clientId, domain: domain);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth0 Demo',
      home: MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();
  Future<String> _message = Future<String>.value('');
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String refreshToken;
  String wRefreshToken;
  String userToken;

  Future<String> _signUp() async {
    dynamic user = await auth.createUser(
        email: usernameController.text,
        password: passwordController.text,
        connection: 'Username-Password-Authentication',
        waitResponse: true);
    return '''[Sign-Up Success] 
    User Id: ${user['_id']}''';
  }

  Future<String> _signIn() async {
    Auth0User user = await auth.passwordRealm(
        username: usernameController.text,
        password: passwordController.text,
        realm: 'Username-Password-Authentication');
    return '''[Sign-In Success] 
    Access Token: ${user.accessToken}''';
  }

  Future<String> _delegationToken() async {
    Auth0User user = await auth.passwordRealm(
        username: usernameController.text,
        password: passwordController.text,
        realm: 'Username-Password-Authentication');
    String token = await auth.delegate(token: user.idToken, api: 'firebase');
    return '''[Delegation Token Success] 
    Access Token: $token''';
  }

  Future<String> _userInfo() async {
    dynamic response = await web.userInfo(token: userToken);
    StringBuffer buffer = new StringBuffer();
    response.forEach((k, v) => buffer.writeln('$k: $v'));
    return '''[User Info] 
    ${buffer.toString()}''';
  }

  Future<String> _resetPassword() async {
    dynamic success = await auth.resetPassword(
        email: usernameController.text,
        connection: 'Username-Password-Authentication');
    return success ? 'Password Reset Success' : 'Password Reset Fail';
  }

  void assignFuture(Function func) {
    setState(() {
      _message = func();
    });
  }

  void webLogin() {
    web
        .authorize(
      audience: 'https://actingweb.eu.auth0.com/userinfo',
      scope: 'openid email offline_access',
    )
        .then((value) {
      print('response: $value');
      wRefreshToken = value['refresh_token'];
      userToken = value['access_token'];
    }).catchError((err) => print('Error: $err'));
  }

  void webRefreshToken() {
    if (wRefreshToken == null) {
      skey.currentState.showSnackBar(SnackBar(
        content: Text('Invalid Refresh Token'),
      ));
      return;
    }
    web
        .refreshToken(refreshToken: wRefreshToken)
        .then((value) => print('response: $value'))
        .catchError((err) => print('Error: $err'));
  }

  void closeSessions() {
    web.clearSession().catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: skey,
      appBar: AppBar(
        leading: Image.network(
            'https://cdn.auth0.com/styleguide/components/1.0.8/media/logos/img/logo-grey.png',
            height: 40),
        backgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Email/Username',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              MaterialButton(
                  child: const Text('Test Sign Up'),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    if (usernameController.text != null &&
                        passwordController.text != null)
                      assignFuture(this._signUp);
                  }),
              MaterialButton(
                  child: const Text('Test Sign In'),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    if (usernameController.text != null &&
                        passwordController.text != null)
                      assignFuture(this._signIn);
                  }),
              MaterialButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  child: const Text('Test Delegation Token'),
                  onPressed: () {
                    if (usernameController.text != null &&
                        passwordController.text != null)
                      assignFuture(this._delegationToken);
                  }),
              MaterialButton(
                  color: Colors.indigo,
                  textColor: Colors.white,
                  child: const Text('Test User Info'),
                  onPressed: () {
                    if (usernameController.text != null &&
                        passwordController.text != null)
                      assignFuture(this._userInfo);
                  }),
              MaterialButton(
                  color: Colors.greenAccent,
                  child: const Text('Test Reset Password'),
                  onPressed: () {
                    if (usernameController.text != null)
                      assignFuture(this._resetPassword);
                  }),
              MaterialButton(
                  color: Colors.lightBlueAccent,
                  child: const Text('Test Web Login'),
                  onPressed: webLogin),
              MaterialButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: const Text('Test Web Refresh Token'),
                  onPressed: webRefreshToken),
              MaterialButton(
                  color: Colors.redAccent,
                  child: const Text('Test Clear Sessions'),
                  onPressed: closeSessions),
              FutureBuilder<String>(
                  future: _message,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    return Text(snapshot.data ?? '',
                        style: const TextStyle(color: Colors.black));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}