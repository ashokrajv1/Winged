import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firestore_search/firestore_search.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class DataModel {
  final String name;
  final double discount;
  final double price;
  final int quantity;

  DataModel({this.name, this.discount, this.price, this.quantity});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;
      return DataModel(
          name: dataMap['name'],
          discount: dataMap['discount'],
          price: dataMap['price'],
          quantity: dataMap['quantity']);
    }).toList();
  }
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirestoreSearchScaffold(
          firestoreCollectionName: 'Products',
          searchBy: 'name',
          appBarBackgroundColor: HexColor('#036f7f'),
          scaffoldBody: const Center(child: Text('Search a product')),
          dataListFromSnapshot: DataModel().dataListFromSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DataModel> dataList = snapshot.data;

              return ListView.builder(
                  itemCount: dataList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final DataModel data = dataList[index];

                    return Card(
                        elevation: 5.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        child: ListTile(
                          tileColor: Colors.white10,
                          title: Text(
                            'Product : ' + '${data.name}',
                            style: TextStyle(color: HexColor('#036f7f')),
                          ),
                          //leading: Icon(Icons.arrow_left),
                          subtitle: Text(
                              'Available Quantity : ${data.quantity}\nDiscount(%) : ${data.discount}\n'),
                          trailing: Text(
                            'Rs.${data.price}',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2),
                          ),
                          onTap: () {},
                        ));
                  });
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Results Returned'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
/*Scaffold(
appBar: AppBar(
leading: IconButton(
icon: Icon(Icons.arrow_back, color: Colors.white),
onPressed: () => Navigator.of(context).pop(),
),
title: Text('Search a product',
style: GoogleFonts.pacifico(
textStyle: TextStyle(color: Colors.white),
fontStyle: FontStyle.italic,
fontSize: 24.0)),
backgroundColor: HexColor('#036f7f'),
centerTitle: true,
),
)

Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data.name}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: Text('${data.quantity}',
                              style: Theme.of(context).textTheme.bodyText1),
                        )
                      ],
                    );


*/
