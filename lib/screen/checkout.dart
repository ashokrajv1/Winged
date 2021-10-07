import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

double total = 0.00;
int count = 0;
double points = 0.00;
var phone = "";
var lines = <Map>[]; // creates an empty

class checkout extends StatefulWidget {
  const checkout({Key key}) : super(key: key);

  @override
  _checkoutState createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  Razorpay _razorpay = Razorpay();
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    count = 0;
    total = 0;
    updatetot();
    //updatepoints();
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    Navigator.pop(context);
  }

  Future<void> updatetot() async {
    double t = 0;
    int c = 0;
    var p = "";
    //final db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final myUid = user.uid;
    await db.collection("User_products").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data()['price']);
        t += (result.data()['price']).toDouble() * result.data()['quantity'];
        c++;
      });
    });
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
      total = t;
      count = c;
      phone = p;
      c = 0;
      t = 0;
    });
  }

  Future<void> updatepoints() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final myUid = user.uid;
    double poi;
    await db
        .collection("Users")
        .where('userid', isEqualTo: myUid.toString())
        .get()
        .then((value) {
      value.docs.forEach((result) {
        poi = double.parse(result.data()['points']);
        print(poi);
      });
    });
    setState(() {
      points = poi;
      total = total - points;
    });
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_TtPLLr32zw8PuR',
      'amount': total * 100,
      'name': 'Winged',
      'description': 'Grocery products Buy',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8248758071', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final myUid = user.uid;
    final db = FirebaseFirestore.instance;
    DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    String date = now.toString().substring(0, 16);
    await db.collection("User_products").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        //db.collection("History").doc().set(result.data());
        lines.add(result.data());
        //print(result.data());
      });
    });
    db.collection("History").add({
      'id': phone,
      'date': date,
      'price': total,
      'items': count,
      'product': lines
    });
    if (points == 0) {
      updatepoints();
      updatetot();
      db
          .collection('Users')
          .doc(myUid)
          .update({'points': (points + (total * 0.01)).toString()});
    } else {
      updatetot();
      db
          .collection('Users')
          .doc(myUid)
          .update({'points': (total * 0.01).toString()});
    }
    //print(l);
    db.collection("User_products").snapshots().forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });
    print("Success");
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Failure");
    _showLocError() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Payment Failed!!!",
            style: TextStyle(color: HexColor('#036f7f')),
          ),
          content: Text("Please re-try after sometimes"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: HexColor('#036f7f'), // background
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("External");
  }

  bool value = false;
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('Check Out',
                    style: GoogleFonts.amiri(
                        fontStyle: FontStyle.italic, fontSize: 30.0)),
                backgroundColor: HexColor('#036f7f'),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "  Items Summary",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic, fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 1.0,
                          width: double.infinity,
                          color: HexColor('#036f7f'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "  -  Item(s)             :   $count",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic, fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "  -  Item(s) cost       :   $total",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic, fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "  -  Handling cost     :   0.00",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic, fontSize: 20.0),
                        ),
                      ),
                      Row(children: [
                        Checkbox(
                          activeColor: HexColor('#036f7f'),
                          value: this.value,
                          onChanged: (bool value) {
                            setState(() {
                              if (this.value == true) {
                                points = 0.0;
                                updatetot();
                                this.value = false;
                              } else {
                                updatepoints();
                                this.value = true;
                              }
                            });
                          },
                        ),
                        Text(
                          "Use Wing'ed points",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic,
                              fontSize: 20.0,
                              color: HexColor('#036f7f')),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "  -  Wing'ed Points cost  (-): $points",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic, fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          height: 1.0,
                          width: double.infinity,
                          color: HexColor('#036f7f'),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "  Total Cost        :  $total ",
                          style: GoogleFonts.amiri(
                              fontStyle: FontStyle.italic,
                              fontSize: 30.0,
                              color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: HexColor('#036f7f'),
                label: Text("Check out"),
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  //updatetot();
                  openCheckout();
                },
              )),
        ));
  }
}
