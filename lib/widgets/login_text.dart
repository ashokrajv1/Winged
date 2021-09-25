import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextLogin extends StatefulWidget {
  @override
  _TextLoginState createState() => _TextLoginState();
}

class _TextLoginState extends State<TextLogin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
      child: Container(
        //color: Colors.green,
        height: 200,
        width: 240,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
            ),
            Center(
              child: Text(
                'you\'re awesome!\nOne step to get \na store in your hand..',
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.white70),
                    fontStyle: FontStyle.italic,
                    wordSpacing: 3,
                    fontSize: 27.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
