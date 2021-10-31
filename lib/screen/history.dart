import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class history extends StatefulWidget {
  const history({Key key}) : super(key: key);

  @override
  _historyState createState() => _historyState();
}

var phone = "";
List<DocumentSnapshot> l;

class _historyState extends State<history> {
  final db = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> history = FirebaseFirestore.instance
      .collection('History')
      .where("id", isEqualTo: phone)
      .snapshots();

  @override
  void initState() {
    super.initState();
    //final db = FirebaseFirestore.instance;
    update();
  }

  Future<void> update() async {
    var p = "";
    //final db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final myUid = user.uid;
    print(myUid);
    await db
        .collection("Users")
        .where('userid', isEqualTo: myUid.toString())
        .get()
        .then((value) {
      value.docs.forEach((result) {
        p = result.data()['mobile'].toString();
      });
    });
    setState(() {
      phone = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('History',
                style: GoogleFonts.pacifico(
                    textStyle: TextStyle(color: Colors.white),
                    fontStyle: FontStyle.italic,
                    fontSize: 28.0)),
            backgroundColor: HexColor('#036f7f'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: history,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return Center(child: Text('No History'));
                  }

                  Map<dynamic, dynamic> map = snapshot.data.docs.asMap();

                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(map.values.toList()[index]["product"]);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  leading: Icon(Icons.shopping_bag_outlined),
                                  title: Text(
                                    'Purchase on : ' +
                                        map.values.toList()[index]["date"],
                                  ),
                                  subtitle: Text('Item(s) : ' +
                                      map.values
                                          .toList()[index]['items']
                                          .toString()),
                                  trailing: Text('Rs.' +
                                      map.values
                                          .toList()[index]['price']
                                          .toString())
                                  /*SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Product: ',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${map.values.toList()[index]["product"]}',
                                      ),
                                    ],
                                  ),
                                ),*/
                                  ),
                            );
                          }),
                    ],
                  );
                }),
          ),
        ));
  }
}
/*Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection('History')
                          .orderBy('date')
                          .where('id', isEqualTo: phone.toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                return new Card(
                                    elevation: 5.0,
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 4, bottom: 4),
                                    child: Column(
                                      children: [
                                        Text('date  :  ' + ds['date']),
                                        Text('id  :  ' + ds['id']),
                                      ],
                                    ));
                              });
                        } else if (snapshot.hasError) {
                          return Text("");
                        } else {
                          return Text("");
                        }
                      }),
                ),

                /*SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection('History')
                          .where("id", isEqualTo: phone)
                          .orderBy('date')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];
                                int count = ds['product'].length;
                                return new Card(
                                    elevation: 5.0,
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 4, bottom: 4),
                                    child: Column(
                                      children: [
                                        Text('date  :  ' + ds['date']),
                                        //Text('id  :  ' + ds['id']),
                                        for (int i = 0; i < count; i++)
                                          new Text(
                                              ds['product'][i]['Product_code']),
                                      ],
                                    ));
                              });
                        } else if (snapshot.hasError) {
                          return Text("yes");
                        } else {
                          return Text("");
                        }
                      }),
                )
              ],
            ),
          ),*/


                */
