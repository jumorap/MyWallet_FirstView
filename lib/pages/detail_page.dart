import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emulateios/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;

  const DetailsPage({Key key, this.params}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  NumberFormat f = new NumberFormat("#,###", "es_COP");

  @override
  Widget build(BuildContext context) {
    // Next 'Consumer (complete)' give us the details for category of expense, when
    // we do click in these category in home_page.dart.
    //
    // We are doing a calling to Firebase to catch the collection 'users', after, by
    // user id, 'expenses' and select two data types 1: [month] and 2: [category].
    // After it, we teach to our users those types returning ListViw.builder,
    // and while is loading these page, teach a loading circular bar
    return Consumer<LoginState>(
        builder: (BuildContext context, LoginState state, Widget child) {

          var user = Provider.of<LoginState>(context).currentUser();
          var _query = Firestore.instance
              .collection('users')
              .document(user.uid)
              .collection('expenses')
              .where("month", isEqualTo: widget.params.month + 1)
              .where("category", isEqualTo: widget.params.categoryName)
              .snapshots();

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.params.categoryName),
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: _query,
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                  if (data.hasData) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        var document = data.data.documents[index];
                        // 'Dismissible' permit us slide the widgets, making unique the
                        // specific widgets with the identifier 'key' [document.documentID]
                        return Dismissible(
                          key: Key(document.documentID),
                          // To erase something from the database Firebase whe we slide to left
                          // or right the widget, thanks to 'Dismissible'
                          //
                          // First catch the 'user', after the user id like [user.uid] and the
                          // 'expenses' where catch the document that is part of these personal
                          // collection and delete the part of document that we wanted remove
                          onDismissed: (direction) {
                            Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .collection('expenses')
                                .document(document.documentID)
                                .delete();
                          },
                          child: ListTile(
                            leading: Stack(
                              // Here, we write the day number into the icon of calendar
                              children: <Widget>[
                                Icon(Icons.calendar_today,
                                  size: 38.0,
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 5,
                                  child: Text(document["day"].toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            title: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5.0)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "\$${f.format(document["value"])}",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        },
                      itemCount: data.data.documents.length,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  },
            ));
        }
    );
  }
}
