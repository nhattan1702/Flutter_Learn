import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BallPage(),
      ),
    );


class BallPage extends StatelessWidget {
  const BallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Text(
            'Ask Me Anything',
            style: TextStyle(
              color: Colors.white,
            ),
            ),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Ball(),
    );
  }
}

class Ball extends StatefulWidget {
  const Ball({super.key});

  @override
  State<Ball> createState() => _BallState();
}

class _BallState extends State<Ball> {

  int ballNumber = 1;

  void changeBallFace () {
      ballNumber = Random().nextInt(5) + 1 ;
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget> [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  changeBallFace();
                });
              },
              child: Image.asset('images/ball$ballNumber.png')),
          ))
        ],
      ),
    );
      
  }
}

