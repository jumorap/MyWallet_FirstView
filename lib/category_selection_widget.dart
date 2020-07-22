import 'package:flutter/material.dart';

class CategorySelectorWidget extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) onValueChanged;

  const CategorySelectorWidget({Key key, this.categories, this.onValueChanged}) : super(key: key);

  @override
  _CategorySelectorWidgetState createState() => _CategorySelectorWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget({Key key, this.name, this.icon, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              //Generate a border to top icons
              border: Border.all(
                //We build a conditional request with "?" like 'if is true(selected is bool) the color is blue, else grey'
                color: selected ? Colors.blueAccent : Colors.grey,
                width: selected ? 3.0 : 1.0,
              ),
            ),
            child: Icon(icon),
          ),
          Text(name,
          style: TextStyle(
            fontSize: selected ? 15.0 : 12.0,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
          ),
        ],
      ),
    );
  }
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  String currentItem = "";

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categories.forEach((name, icon) {
      //Here we have a gesture detector, that help to know if an icon was selected
      widgets.add(GestureDetector(
        onTap: () {
          setState(() {
            currentItem = name;
          });
          widget.onValueChanged(name);
        },
        child: CategoryWidget(
          name: name,
          icon: icon,
          selected: name == currentItem,
        )
      ));
    });
    return ListView(
      //With the next line we do that the direction of list (container of icons) stay horizontal
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}
