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
                style: GoogleFonts.amiri(
                    fontStyle: FontStyle.italic, fontSize: 30.0)),
            backgroundColor: HexColor('#036f7f'),
            centerTitle: true,
          ),
          body: SafeArea(
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
                ),*/
