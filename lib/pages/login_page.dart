import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_state.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Ingresar"),
          onPressed: () {
            Provider.of<LoginState>(context).login();
          },
        ),
      ),
    );
  }
}
