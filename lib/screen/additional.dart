//import 'package:firebase_database/firebase_database.dart';
//import 'package:geocoder/geocoder.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:winged/screen/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

double distance = 0;
double lati = 11.2778116;
double longi = 77.1678508;
var loc = "";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  String er = '';
  int exist = 0;
  String num;
  AnimationController _controller;
  Animation<double> _animation;
  //final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _controller.forward();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
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

  void _onChanged(String value) {
    setState(() {
      const pattern = r'^[6789]{1}[0-9]{9}$';
      final regExp = RegExp(pattern);
      if (regExp.hasMatch(value) && value.length == 10) {
        er = 'valid';
        num = value;
      } else if (value.length == 0) {
        er = 'mobile number can\'t be empty';
      } else {
        er = 'Invalid mobile number';
      }
    });
  }

  void _onSubmitted(String value) {
    setState(() {
      er = er;
      num = value;
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 180, bottom: 30),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(''),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                style: TextStyle(color: Colors.blue, fontSize: 17.0),
                //autofocus: true,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide(
                        color: (er == 'valid' ? Colors.green : Colors.pink),
                        width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: (er == 'valid' ? Colors.green : Colors.pink),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(
                    color: (er == 'valid' ? Colors.green : Colors.pink),
                  ),
                  hintText: 'Enter a Mobile Number',
                  hintStyle: TextStyle(color: Colors.white),
                  //    icon: Icon(Icons.phone_android),
                ),
                onChanged: _onChanged,
                onSubmitted: _onSubmitted,
                keyboardType: TextInputType.number,
              ),
              Text(
                er,
                style: TextStyle(
                  color: (er == 'valid' ? Colors.green : Colors.pink),
                ),
              ),
              Text(''),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  side: BorderSide(width: 1.3, color: Colors.pink),
                ),
                child:
                    Text('Let\'s  Wing\'ed', style: TextStyle(fontSize: 17.0)),
                onPressed: () async {
                  getCurrentLocation();
                  if (er == 'valid' && distance < 200) {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        if (doc['mobile'] == num) {
                          print(doc['mobile']);
                          exist = 1;
                        }
                      });
                    });
                    if (exist == 1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Start(num: num)));
                      exist = 0;
                    } else {
                      db
                          .collection('Users')
                          .add({'mobile': num, 'name': " ", 'points': "0.0"});
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Start(num: num)));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.pink,
                        content: const Text(
                          'Failed!!!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal:
                              40.0, // Inner padding for SnackBar content.
                        ),
                        duration: const Duration(milliseconds: 1500),
                        width: 280.0, // Width of the SnackBar.
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              ScaleTransition(
                  scale: _animation,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.pinkAccent,
                          size: 30,
                        ),
                      ])),
              Text(
                (distance <= 200)
                    ? "Valid Location" + distance.toString() + loc
                    : "Invalid Location" + distance.toString() + loc,
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
appBar: AppBar(
        title: Text(
          'Wing\'ed',
          style: TextStyle(fontSize: 25.0),
        ),
      ),

Container(
                  child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage(
                        'assets/gif/pin.gif',
                      ))),

showDialog(
context: context,
barrierDismissible: false,
builder: (context) {
return Scaffold(
body: SafeArea(
child: SingleChildScrollView(
child: Column(
children: <Widget>[
Container(child: Text("OTP")),
Padding(
padding: const EdgeInsets.symmetric(vertical: 8.0),
child: Text(
'Phone Number Verification',
style: TextStyle(
fontWeight: FontWeight.bold, fontSize: 18),
textAlign: TextAlign.center,
),
),
Padding(
padding: const EdgeInsets.symmetric(vertical: 8.0),
child: Text(
'Enter the code sent to ${phone}',
style: TextStyle(fontSize: 18),
textAlign: TextAlign.center,
),
),
Container(
alignment: Alignment.center,
margin: EdgeInsets.symmetric(horizontal: 40),
child: TextField(
decoration: InputDecoration(labelText: 'OTP'),
onChanged: _onChangedotp,
onSubmitted: _onSubmittedotp,
),
),
SizedBox(height: size.height * 0.03),
Container(
alignment: Alignment.center,
margin: EdgeInsets.symmetric(horizontal: 40),
child: ElevatedButton(
onPressed: () async {
final code = otp.trim();
print(code);

AuthCredential credential =
PhoneAuthProvider.credential(
verificationId: verificationId,
smsCode: code);

UserCredential result =
await _auth.signInWithCredential(credential);

User user = result.user;

print("User = " + user.toString());

//addUser(phone);

if (user != null) {
db.collection('Users').add({
'mobile': num,
'name': name,
'userid': user.uid,
'points': "0.0"
});
Navigator.canPop(context);
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => Start(num: num)));
} else {
print("Error");
}
},
child: Text(
"VERIFY",
style: TextStyle(fontSize: 16, letterSpacing: 1),
),
),
),
Container(
alignment: Alignment.center,
margin:
EdgeInsets.symmetric(horizontal: 40, vertical: 10),
child: GestureDetector(
onTap: () {
loginUser(phone, context);
},
child: Text(
"Didn't receive a code? Resend",
style: TextStyle(fontSize: 14),
),
),
),
],
)
),
),
);
},
);
},
codeAutoRetrievalTimeout: null);
}*/
