import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalText extends StatefulWidget {
  @override
  _VerticalTextState createState() => _VerticalTextState();
}

class _VerticalTextState extends State<VerticalText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10),
      child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            'LOGIN',
            style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.white),
                fontStyle: FontStyle.italic,
                letterSpacing: 6,
                fontWeight: FontWeight.bold,
                fontSize: 38.0),
          )),
    );
  }
}
