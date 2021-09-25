import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:winged/screen/cart_items.dart';
import 'package:hexcolor/hexcolor.dart';

double distance = 201;
double lati = 11.2778116;
double longi = 77.1678508;
var loc = "";

class Qr extends StatefulWidget {
  const Qr({Key key}) : super(key: key);

  @override
  _QrState createState() => _QrState();
}

class _QrState extends State<Qr> {
  String _scanBarcode = 'Unknown';
  int quantity = 1;
  final db = FirebaseFirestore.instance;
  FToast fToast;
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getCurrentLocation();
  }

  _showToast(num val) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high_outlined),
          SizedBox(
            width: 12.0,
          ),
          (val == 1)
              ? Text("Minimum quality is 1")
              : (val == 20)
                  ? Text("Maximum quality at once is 20")
                  : Text(""),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showLocError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Location Access Failed!!!",
          style: TextStyle(color: HexColor('#036f7f')),
        ),
        content: Text("Please allow location services for this Application"),
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

  void getCurrentLocation() async {
    //await Future.delayed(const Duration(seconds: 2), () {});
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() async {
      loc = "$position";
      //final coordinates =new Coordinates(position.latitude, position.longitude);
      //var add = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      //var first = add.first;
      //String address = first.featureName.toString();
      distance = Geolocator.distanceBetween(
          lati, longi, position.latitude, position.longitude);
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != "-1") {
        _scanBarcode = barcodeScanRes;
        showdialog();
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      if (barcodeScanRes != "-1") {
        _scanBarcode = barcodeScanRes;
        showdialog();
      }
    });
  }

  void showdialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: (Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 100, bottom: 16, left: 16, right: 16),
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 10.0))
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: HexColor("#30C591"),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          ' PRODUCT ',
                          style: TextStyle(
                            fontSize: 20.0,
                            //backgroundColor: HexColor("#30C591"),
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          _scanBarcode,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          ' QUANTITY ',
                          style: TextStyle(
                            fontSize: 20.0,
                            //backgroundColor: HexColor("#30C591"),
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          //margin: EdgeInsets.all(0),
                          padding: EdgeInsets.only(
                              left: 90, top: 10, right: 90, bottom: 0),
                          child: NumberInputPrefabbed.roundedButtons(
                            scaleHeight: 0.9,
                            controller: TextEditingController(),
                            incIconColor: HexColor('#30C591'),
                            decIconColor: HexColor('#30C591'),
                            initialValue: 1,
                            min: 1,
                            max: 20,
                            onIncrement: (num val) {
                              quantity = val;
                              if (val == 20) {
                                _showToast(val);
                              }
                            },
                            onDecrement: (num val) {
                              quantity = val;
                              if (val == 1) {
                                _showToast(val);
                              }
                            },
                            onSubmitted: (num val) {
                              quantity = val;
                            },
                            numberFieldDecoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide(
                                    color: HexColor('#30C591'), width: 2.0),
                              ),
                            ),
                            decIconSize: 25,
                            incIconSize: 25,
                            buttonArrangement:
                                ButtonArrangement.incRightDecLeft,
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                if (quantity > 0) {
                                  db.collection('User_products').add({
                                    'Product_code': _scanBarcode,
                                    'name': '',
                                    'quantity': quantity,
                                    'datetime': DateTime.now()
                                  });
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.pink,
                                      content: const Text(
                                        'Quantity should be greater than 0',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            40.0, // Inner padding for SnackBar content.
                                      ),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      width: 280.0, // Width of the SnackBar.
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('ADD'),
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor("#30C591"),
                                  onPrimary: Colors.white),
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 2,
                      left: 16,
                      right: 16,
                      child: CircleAvatar(
                        //backgroundColor: Colors.lightBlueAccent,
                        radius: 50.0,
                        backgroundImage: AssetImage('assets/gif/addcart.gif'),
                      ))
                ],
              ),
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                    child: Container(
                      //color: Colors.green,
                      height: 200,
                      width: 280,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              'you\'re awesome!\nJust tap below to scan \nthe products in your hand',
                              style: GoogleFonts.lato(
                                  textStyle:
                                      TextStyle(color: HexColor('#036f7f')),
                                  fontStyle: FontStyle.italic,
                                  wordSpacing: 3,
                                  fontSize: 25.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 120.00,
                              height: 120.00,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/lbr.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: HexColor('#036f7f'), width: 5)),
                            ),
                            onTap: () {
                              if (distance <= 200)
                                scanBarcodeNormal();
                              else
                                _showLocError();
                            },
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: HexColor('#036f7f'), // background
                              ),
                              onPressed: () {
                                if (distance <= 200)
                                  scanBarcodeNormal();
                                else
                                  _showLocError();
                              },
                              child: Text('Barcode Scan')),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                              child: Container(
                                width: 120.00,
                                height: 120.00,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/lqr.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                        color: HexColor('#036f7f'), width: 5)),
                              ),
                              onTap: () {
                                if (distance <= 200)
                                  scanQR();
                                else
                                  _showLocError();
                              }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: HexColor('#036f7f'), // background
                              ),
                              onPressed: () {
                                if (distance <= 200)
                                  scanQR();
                                else
                                  _showLocError();
                              },
                              child: Text('     QR  Scan     ')),
                        ],
                      )
                    ],
                  ),
                  /*Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.label_important,
                        color: HexColor('#036f7f'),
                      ),
                      Text(' if Barcode/Qrcode not recognized click here',
                          style: TextStyle(color: HexColor('#036f7f'))),
                    ],
                  ),*/
                  SizedBox(height: 110),
                  Container(
                    height: 100,
                    width: 140,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/gif/loc.gif'),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  /*Text(
                    (distance <= 200)
                        ? "Valid Location" + distance.toString() + loc
                        : "Invalid Location" + distance.toString() + loc,
                    style: TextStyle(color: Colors.green),
                  ),*/
                ],
              ),
            ),
          ),
        ));
  }
}

/*void showdialog() {
    showDialog(
        context: context,
        builder: (context) {
          return (AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text('Add Product'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    _scanBarcode,
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    db.collection('User_products').add({
                      'Product_code': _scanBarcode,
                      'name': '',
                      'quantity': 1,
                      'datetime': DateTime.now()
                    });
                    Navigator.pop(context);
                  },
                  child: Text('ADD'))
            ],
          ));
        });
  }

  floatingActionButton: FloatingActionButton(
            child: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => cart()));
            },
          )



  */
