import 'package:emulateios/login_state.dart';
import 'package:emulateios/pages/add_page.dart';
import 'package:emulateios/pages/detail_page.dart';
import 'package:emulateios/pages/home_page.dart';
import 'package:emulateios/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //By suggestion from Google, was included "ChangeNotifierProvider" way the class login_state
    // was used because is necessary send the state of [_loggedIn] in different class to know when
    // an user is logged and the app "remember" this state
    return ChangeNotifierProvider<LoginState>(
      builder: (BuildContext context) => LoginState(),
      //create: (BuildContext context) async => LoginState(),
      //lazy: false,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        // With 'onGenerateRoute' we can build a "temporal" page. Where
        // we gonna teach to our users the details of specific expenses
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments;
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailsPage(
                  params: params,
                );
              }
            );
          }
        },

        routes: { //Declare the routes-pages-layouts to surf about the app
          '/': (BuildContext context) {
            //To define the Layout that appear to our users, depending if they are logged or not
            // we use the class LoginState defined before
            var state = Provider.of<LoginState>(context);
            if (state.isLoggedIn()) {
              return MyHomePage();
            } else {
              return LoginPage();
            }
          },
        '/add': (BuildContext context) => AddPage(),
        },
      ),
    );
  }
}

