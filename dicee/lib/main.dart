import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Center(child: Text('Dicee')),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}


class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;

  void changeDiceFace () {
        leftDiceNumber = Random().nextInt(6) + 1 ;
        rightDiceNumber = Random().nextInt(6) +1 ;
  }


 @override
  Widget build (BuildContext context) {
    return Center(
      child: Row(
        children: <Widget> [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    changeDiceFace();
                  });
                  },
                child: Image.asset('images/dice$leftDiceNumber.png')
              
              ),
            )),
            Expanded(
              child: TextButton(
                onPressed: () {
                  print('word');
                },
                child: TextButton(
                  onPressed: () {
                    setState(() {
                     changeDiceFace();
                    });
                  },
                  child: Image.asset('images/dice$rightDiceNumber.png'))))
        ],
      ),
    );
  }
}

