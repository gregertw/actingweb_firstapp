import 'package:flutter/material.dart';
import 'package:first_app/ui/pages/login/index.dart';

class WaitPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(40.0),
      child: Image.asset('assets/actingweb-header-small.png'),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome to ActingWeb...',
        style: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.grey,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[logo, welcome, LoginScreen()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
