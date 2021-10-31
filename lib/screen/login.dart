import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:winged/screen/start.dart';
import 'package:winged/widgets/login_text.dart';
import 'package:winged/widgets/vertical_login.dart';

class login extends StatefulWidget {
  const login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  final db = FirebaseFirestore.instance;
  String er = '';
  String ern = '';
  int exist = 0;
  String num;
  String name = "";
  int display_name_field = 0;
  int display_button = 0;
  String otp;

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (phone[0] != "+") phone = "+91" + phone;
    print("Phone = " + phone);

    await _auth.verifyPhoneNumber(
        phoneNumber: phone.trim(),
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          User user = userCredential.user;
          print("User = " + user.toString());

          if (user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Start(num: num)));
          }
          //This callback would gets called when verification is done automatically
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is invalid.');
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          //This callback would gets called when verification is not done automatically
          Size size = MediaQuery.of(context).size;
          showDialog(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: (Dialog(
                    insetPadding: EdgeInsets.only(
                        top: 100, bottom: 20, left: 30, right: 30),
                    backgroundColor: HexColor('#036f7f'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 100, bottom: 16, left: 16, right: 16),
                          margin: EdgeInsets.only(top: 50),
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
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  child: Text(
                                "OTP",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#036f7f'),
                                    fontSize: 25),
                                textAlign: TextAlign.center,
                              )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'Phone Number Verification',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: HexColor('#036f7f'),
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Enter the OTP sent to \n ${phone}',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 40),
                                child: TextField(
                                  style: TextStyle(
                                      color: HexColor('#036f7f'),
                                      letterSpacing: 20,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 25),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: HexColor('#036f7f'),
                                    labelText: 'OTP',
                                    counterText: "",
                                    labelStyle: TextStyle(
                                        color: Colors.black87,
                                        letterSpacing: 2,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  onChanged: _onChangedotp,
                                  onSubmitted: _onSubmittedotp,
                                  keyboardType: TextInputType.number,
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

                                    UserCredential result = await _auth
                                        .signInWithCredential(credential);

                                    User user = result.user;

                                    print("User = " + user.toString());

                                    //addUser(phone);

                                    if (user != null) {
                                      db.collection('Users').doc(user.uid).set({
                                        'mobile': num,
                                        'name': name,
                                        'userid': user.uid,
                                        'points': 0.0
                                      });
                                      Navigator.canPop(context);
                                      Navigator.canPop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Start(num: num)));
                                    } else {
                                      print("Error");
                                    }
                                  },
                                  child: Text(
                                    "VERIFY",
                                    style: TextStyle(
                                        fontSize: 16, letterSpacing: 1),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: HexColor('#036f7f'),
                                      onPrimary: Colors.white),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
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
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 16,
                          right: 16,
                          child: Container(
                            child: CircleAvatar(
                              //backgroundColor: Colors.lightBlueAccent,
                              radius: 65.0,
                              backgroundImage:
                                  AssetImage('assets/gif/verify.gif'),
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: HexColor('#036f7f'),
                                width: 3.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
                );
              });

          /* showDialog(
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
          );*/
        },
        codeAutoRetrievalTimeout: null);
  }

  void _onChanged(String value) {
    setState(() {
      const pattern = r'^[6789]{1}[0-9]{9}$';
      final regExp = RegExp(pattern);
      if (regExp.hasMatch(value) && value.length == 10) {
        er = 'valid';
        num = value;
      } else {
        er = '';
      }
    });
  }

  void _onSubmitted(String value) {
    setState(() {
      er = er;
      num = value;
    });
  }

  void _onChangedname(String value) {
    setState(() {
      if (value.length > 0)
        ern = "valid";
      else
        ern = "";
      name = value;
    });
  }

  void _onSubmittedname(String value) {
    setState(() {
      if (value.length > 0)
        ern = "valid";
      else
        ern = "";
      name = value;
    });
  }

  void _onChangedotp(String value) {
    setState(() {
      otp = value;
    });
  }

  void _onSubmittedotp(String value) {
    setState(() {
      otp = value;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [HexColor('#04191d'), HexColor('#036f7f')]),
      ),
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Wing\'ed',
                style: GoogleFonts.pacifico(
                    textStyle: TextStyle(color: Colors.white),
                    fontStyle: FontStyle.italic,
                    fontSize: 45.0),
              ),
              Row(
                children: [
                  SizedBox(width: 30),
                  VerticalText(),
                  SizedBox(width: 20),
                  TextLogin()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    maxLength: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white70,
                        labelText: 'Mobile Number',
                        counterText: "",
                        labelStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        suffixIcon: (er == 'valid')
                            ? IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    display_name_field = 1;
                                    display_button = 1;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              )
                            : Text("")),
                    onChanged: _onChanged,
                    onSubmitted: _onSubmitted,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
                child: (display_name_field == 1)
                    ? Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          autofocus: true,
                          maxLength: 30,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white70,
                            labelText: 'First Name',
                            counterText: "",
                            labelStyle: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          onChanged: _onChangedname,
                          onSubmitted: _onSubmittedname,
                          keyboardType: TextInputType.name,
                        ),
                      )
                    : Text(""),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 50, left: 200),
                child: (display_button == 1)
                    ? Container(
                        alignment: Alignment.bottomRight,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: HexColor('#036f7f'),
                              blurRadius:
                                  10.0, // has the effect of softening the shadow
                              spreadRadius:
                                  1.0, // has the effect of extending the shadow
                              offset: Offset(
                                5.0, // horizontal, move right 10
                                5.0, // vertical, move down 10
                              ),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: () {
                            loginUser(num, context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Get OTP',
                                style: TextStyle(
                                  color: HexColor('#036f7f'),
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: HexColor('#036f7f'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Text(""),
                      ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
