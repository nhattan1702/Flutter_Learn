import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: Colors.greenAccent[700],
        appBar: AppBar(
          title: Center(child: Text('i am poor')),
          backgroundColor: Colors.white,
          ),

        body: Center(
          child: Image(image: AssetImage('images/cat.jpg')),
        ),
      ),
    ),
  );
}
