import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import 'checkout.dart';

class cart extends StatefulWidget {
  const cart({Key key}) : super(key: key);

  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  final db = FirebaseFirestore.instance;
  void showdialog(String _scanBarcode, String quantity, DocumentSnapshot ds) {
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
                          'Edit Your Product',
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
                            initialValue: int.parse(quantity),
                            min: 1,
                            max: 20,
                            onIncrement: (num val) {
                              quantity = val.toString();
                            },
                            onDecrement: (num val) {
                              quantity = val.toString();
                            },
                            onSubmitted: (num val) {
                              quantity = val.toString();
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
                                db
                                    .collection('User_products')
                                    .doc(ds.id)
                                    .update({'quantity': quantity});
                                Navigator.pop(context);
                              },
                              child: Text('EDIT'),
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
            body: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('User_products')
                    .orderBy('datetime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Card(
                              elevation: 5.0,
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 4, bottom: 4),
                              child: ListTile(
                                tileColor: Colors.white10,
                                title: Text(
                                  'Product : ' + ds['Product_code'],
                                  style: TextStyle(color: HexColor('#036f7f')),
                                ),
                                subtitle: Text(
                                    'Quantity : ' + ds['quantity'].toString()),
                                trailing: Text("Rs.20"),
                                onTap: () {
                                  showdialog(ds['Product_code'].toString(),
                                      ds['quantity'].toString(), ds);
                                },
                              ),
                            ),
                            actions: [],
                            secondaryActions: [
                              new IconSlideAction(
                                caption: 'Delete',
                                color: Colors.redAccent,
                                icon: Icons.delete,
                                onTap: () {
                                  db
                                      .collection('User_products')
                                      .doc(ds.id)
                                      .delete();
                                },
                              ),
                            ],
                          );
                        });
                  } else if (snapshot.hasError) {
                    return CircularProgressIndicator();
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: HexColor('#036f7f'),
              label: Text("Check Out"),
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => checkout()));
              },
            )));
  }
}
