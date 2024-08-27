import 'package:flutter/material.dart';

void main() { 
  runApp(
    MaterialApp( debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[600],
        appBar: AppBar(
          title: Center(child: Text('I am rich')),
          backgroundColor: Colors.blueGrey[400],
        ),
        body:  Center(
          child: Image(
            image: AssetImage('images/diamond.png'),
          ),
        ),
      ),
    ),
  );
}