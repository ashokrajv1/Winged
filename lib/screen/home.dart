import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';

final List<String> imgList = [
  'https://cdn.dribbble.com/users/1056774/screenshots/3634302/_typography_sale_sold4-03_animation800x600.gif',
  'https://www.uidownload.com/files/450/591/795/phone-animation-freebie.gif',
  'https://i.pinimg.com/originals/60/d0/fd/60d0fd6b94550d0d6f57131e3dcdf1fa.gif',
  'https://i.pinimg.com/originals/a9/5c/29/a95c29234095b3d8eed338cb4f7e8003.png',
  'https://www.uschamber.com/sites/default/files/023098_tjd_commentary_onlineshopping_atf.gif',
  'https://www.starpik.com/wp-content/uploads/2019/07/Supermarket-shopping-sale-banner-Vector.-Food-products-and-drinks-illustration-170161.jpg',
  'https://i.pinimg.com/originals/27/6f/dd/276fdd2157b745a55c76c5411fa6f60a.gif',
  'https://i.pinimg.com/originals/4b/09/84/4b0984999655a729424a607d769d6a13.gif'
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(100, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(""),
                        /*'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),*/
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class home extends StatefulWidget {
  const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  final db = FirebaseFirestore.instance;
  Offset position = Offset(20.0, 20.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 3.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 2,
                  autoPlay: true,
                ),
                items: imageSliders,
              )),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  height: 1,
                  width: double.infinity,
                  color: HexColor('#036f7f'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('Products')
                        .orderBy('datetime')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return Card(
                                elevation: 5.0,
                                margin: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Image.network(ds["product_img"],
                                          width: 180,
                                          height: 90,
                                          fit: BoxFit.fill),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Text(ds["name"],
                                              style: TextStyle(
                                                  color: HexColor('#036f7f'),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 2),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          margin: EdgeInsets.fromLTRB(
                                              10.0, 3.0, 10.0, 0.0),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Price : " +
                                                    ds["price"].toString(),
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 2),
                                              ),
                                              SizedBox(
                                                height: 28,
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: HexColor(
                                                          '#036f7f'), // background
                                                    ),
                                                    onPressed: () {},
                                                    child:
                                                        Text(' Add to Cart ')),
                                              )
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10.0, 0.0, 10.0, 8.0),
                                              child: Text(
                                                "Product discount(%) : " +
                                                    ds['discount'].toString(),
                                                style: TextStyle(
                                                    color: HexColor('#036f7f'),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 1),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("");
                      } else {
                        return Text("");
                      }
                    }),
              ),
              SizedBox(
                height: 11,
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*

Container(
                  child: IconButton(
                icon: Image.asset('assets/gif/qrbar.gif'),
                iconSize: 300,
                onPressed: () {},
              ))


Card(
                                      elevation: 5.0,
                                      color: Colors.white,
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 4,
                                          bottom: 4),
                                      child: ListTile(
                                        tileColor: Colors.white10,
                                        title: Text(
                                          'Product : ' +
                                              ds['name'] +
                                              " (" +
                                              ds['Product_code'] +
                                              ")",
                                          style: TextStyle(
                                              color: HexColor('#036f7f')),
                                        ),
                                        //leading: Icon(Icons.arrow_left),
                                        subtitle: Text('Quantity : ' +
                                            ds['quantity'].toString()),
                                        trailing: Text('Rs.'),
                                        onTap: () {
                                          // showdialog(ds['Product_code'].toString(),ds['quantity'],ds);
                                        },
                                      ),
                                    );

Container(
                                  child: Card(
                                    elevation: 5.0,
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Image.network(
                                              "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/118898040/original/870e2763755963f5a300574bbea5977fa8b18460/sell-original-football-and-basketball-teams-jersey.jpg",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              child: Text("product",
                                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                                              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                                  child: Text("prod")),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [Text("Price"), Text("ADD TO CART")],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );


class home1 extends StatelessWidget {
  const home1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  initialPage: 2,
                  autoPlay: true,
                ),
                items: imageSliders,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

Container(
                  child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40), // if you need this
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            //color: Colors.white,
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrwxvFzY1AOacCoF0yiSaOeDWOv3BPy4Qsew&usqp=CAU"),
                                    fit: BoxFit.contain)),
                            child: Text(
                              "Kitkat    ₹10",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18, color: HexColor('#036f7f')),
                            ),
                            alignment: Alignment(-0.2, 1.0),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40), // if you need this
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            //color: Colors.white,
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrwxvFzY1AOacCoF0yiSaOeDWOv3BPy4Qsew&usqp=CAU"),
                                    fit: BoxFit.contain)),
                            child: Text(
                              "Kitkat    ₹10",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18, color: HexColor('#036f7f')),
                            ),
                            alignment: Alignment(-0.2, 1.0),
                          ),
                        ),
                      ]),
                ),
Container(
                  child: Row(children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40), // if you need this
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        //color: Colors.white,
                        width: 380,
                        height: 180,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrwxvFzY1AOacCoF0yiSaOeDWOv3BPy4Qsew&usqp=CAU"),
                                fit: BoxFit.contain)),
                        child: Text(
                          "Kitkat     ₹10",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontFamily: "Hind",
                              fontSize: 23,
                              color: HexColor('#036f7f')),
                        ),
                        alignment: Alignment(0.0, 1.0),
                      ),
                    ),
                  ]),
                ),
                Container(
                  child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40), // if you need this
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            //color: Colors.white,
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrwxvFzY1AOacCoF0yiSaOeDWOv3BPy4Qsew&usqp=CAU"),
                                    fit: BoxFit.contain)),
                            child: Text(
                              "Kitkat    ₹10",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18, color: HexColor('#036f7f')),
                            ),
                            alignment: Alignment(-0.2, 1.0),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(40), // if you need this
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Container(
                            //color: Colors.white,
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrwxvFzY1AOacCoF0yiSaOeDWOv3BPy4Qsew&usqp=CAU"),
                                    fit: BoxFit.contain)),
                            child: Text(
                              "Kitkat    ₹10",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18, color: HexColor('#036f7f')),
                            ),
                            alignment: Alignment(-0.2, 1.0),
                          ),
                        ),
                      ]),
                ),
*/
