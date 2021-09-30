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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 2.0,
                    width: double.infinity,
                    color: HexColor('#036f7f'),
                  ),
                ),
                SizedBox(
                  height: 20,
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
                Container(
                    child: IconButton(
                  icon: Image.asset('assets/gif/qrbar.gif'),
                  iconSize: 300,
                  onPressed: () {},
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*class home1 extends StatelessWidget {
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
}*/
