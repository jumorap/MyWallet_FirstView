import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_state.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Coming from the class 'login_state.dart', we generate a CircularProgressIndicator
        // teaching to our users a loading bar circular progress
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child) {
            if (value.isLoading()) {
              return CircularProgressIndicator();
            } else {
              return child;
            }
          },
          child: RaisedButton(
            child: Text("Ingresar"),
            onPressed: () {
              Provider.of<LoginState>(context).login();
            },
          ),
        ),
      ),
    );
  }
}
