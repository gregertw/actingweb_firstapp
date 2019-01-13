import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:first_app/pages/wait/index.dart';

final String clientId = 'PJVgy3Vh9jo7Wxl6sSUZsicE6S4TXZjB';
final String domain = 'actingweb.eu.auth0.com';

final WebAuth web = new WebAuth(clientId: clientId, domain: domain);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();
  var _result;

  Future<String> _delegationToken() async {
    if (_result == null) {
      return null;
    }
    String token = await web.delegate(token: _result['id_token'], api: 'firebase');
    return '''[Delegation Token Success] 
    Access Token: $token''';
  }

  Future<String> _userInfo() async {
    if (_result == null) {
      return null;
    }
    dynamic response = await web.userInfo(token: _result['access_token']);
    StringBuffer buffer = new StringBuffer();
    response.forEach((k, v) => buffer.writeln('$k: $v'));
    return '''[User Info] 
    ${buffer.toString()}''';
  }

  void _refreshToken() {
    if (_result && _result['refresh_token'] == null) {
      skey.currentState.showSnackBar(SnackBar(
        content: Text('Invalid Refresh Token'),
      ));
      return;
    }
    web
        .refreshToken(refreshToken: _result['refresh_token'])
        .then((value) => print('response: $value'))
        .catchError((err) => print('Error: $err'));
  }

  void _closeSessions() {
    web.clearSession().catchError((err) => print(err));
  }

  @override
  initState() {
    super.initState();
    web.authorize(
      audience: 'https://actingweb.eu.auth0.com/userinfo',
      scope: 'openid email offline_access',
    ).then((value) {
      setState(() {
        _result = value;
      });
      Navigator.pushNamed(context, "/HomePage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WaitPage();
  }
}