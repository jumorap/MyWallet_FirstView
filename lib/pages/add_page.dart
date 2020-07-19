import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../category_selection_widget.dart';
import 'package:flutter/src/widgets/heroes.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category = "";
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,//We dont wanna that see the appBar
        title: Text("Categorías (7)",
          style: TextStyle(
            color: Colors.grey,
          )
        ),
        centerTitle: false,
        actions: <Widget>[//Next button have the function of close the activity
          IconButton(
            icon: Icon(Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 70.0,
      child: CategorySelectorWidget(//Send the categories to category_selector_widget to build images and text in top of activity
        //Send the name and image in a data structure Map
        categories: {
          "Compras": Icons.shopping_cart,
          "Diversión": FontAwesomeIcons.beer,
          "Alimentos": FontAwesomeIcons.hamburger,
          "Recibos": FontAwesomeIcons.wallet,
          "Tarjetas": FontAwesomeIcons.creditCard,
          "Impuestos": FontAwesomeIcons.listAlt,
          "Imprevisto": FontAwesomeIcons.frown,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text("\$${realValue.toStringAsFixed(0)}",
        style: TextStyle(
          fontSize: 40.0,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _num(String text, double height) {
    //This function define the height and font size of writer
    return GestureDetector(
      //To detect the white parts in buttons, we write te next line
      behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (text == "000") {
              value = value * 1000;
            } else {
              value = value * 10 + int.parse(text);
            }
          });
          },
        child: Container(
          height: height,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 35,
                color: Colors.grey,
              ),
            ),
          ),
        ),
    );
  }
  Widget _numpad() {
    return Expanded(
      //Design a table to build buttons where gonna write the numbers-expenses our users
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var height = constraints.biggest.height / 4;
          return Table(
            border: TableBorder.all(
              color: Colors.grey,
              width: 1.0,
            ),
            children: [
              TableRow(children: [
                _num("1", height),
                _num("2", height),
                _num("3", height),
              ]),
              TableRow(children: [
                _num("4", height),
                _num("5", height),
                _num("6", height),
              ]),
              TableRow(children: [
                _num("7", height),
                _num("8", height),
                _num("9", height),
              ]),
              TableRow(children: [
                _num("000", height),
                _num("0", height),
                GestureDetector(
                  //To detect the white parts in buttons, we write te next line
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      value = value ~/ 10;
                    });
                  },
                  child: Container(
                    height: height,
                    child: Center(
                      child: Icon(
                        Icons.backspace,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                )
              ]),
            ],
          );
      }),
    );
  }

  Widget _submit() {
    return Builder(builder: (BuildContext context) {
      return Hero(//Here continued the animation from home page > FloatingActionButton
        tag: "add_button",
        child: Container(
          height: 65.0,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: MaterialButton(
            child: Text(
              "Añadir gasto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            onPressed: () {
              if (value > 0 && category != "") {
                Firestore.instance
                    .collection('expenses')
                .document()
                .setData({
                  "category": category,
                  "value": value,
                  "month": DateTime.now().month,
                  "day": DateTime.now().day,
                });
                Navigator.of(context).pop();
              } else {
                //When the condition is false, here present an message in screen. That is button
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Asigna un valor válido y una categoría a tu gasto")));
              }
            },
          ),
        ),
      );
    });
  }
}


