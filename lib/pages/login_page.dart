import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../login_state.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Text(
              "Mis gastos",
              style: TextStyle(
                fontSize: 38.0,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w400,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/intro_image.png'),
            ),
            Text(
              "Administra tus gastos",
              style: Theme.of(context).textTheme.caption,
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget child) {
                if (value.isLoading()) return CircularProgressIndicator();
                else return child;
              },
              // To build a button with an image and text, inclusive
              // styling these, we can use 'child: OutlineButton.icon'
              // where we use 'Text' like label.
              //
              // This class of button have a transparent background color
              // and when be selected have gray color. Twin with border
              child: OutlineButton.icon(
                icon: Icon(
                  FontAwesomeIcons.google,
                  size: 20.0,
                ),
                label: Text(
                  "Ingresar con Google",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                ),
                onPressed: () => Provider.of<LoginState>(context).login(),
                shape: StadiumBorder(),
                highlightColor: Colors.blueAccent[100],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  text: "Al ingresar, está aceptando nuestros ",
                  children: [
                    // We can make clickable text
                    TextSpan(
                      text: "Términos, Condiciones",
                      //recognizer: _recognizer1,
                      style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " y  "),
                    TextSpan(
                      text: "Políticas de Privacidad",
                      //recognizer: _recognizer2,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
