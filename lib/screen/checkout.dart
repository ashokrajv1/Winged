import 'package:flutter/material.dart';

class checkout extends StatefulWidget {
  const checkout({Key key}) : super(key: key);

  @override
  _checkoutState createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            body: CircularProgressIndicator(),
          ),
        ));
  }
}
