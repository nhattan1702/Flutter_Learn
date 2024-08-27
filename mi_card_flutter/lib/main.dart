import 'package:flutter/material.dart';

void main() {
  runApp(
   MyApp()
  );
}


class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              CircleAvatar( 
                radius: 50.0,
                backgroundImage: AssetImage('images/cat.jpg'),
              ),
              Text(
                'Sweet Cat',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                'FLUTTER DEVELOPER',
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20.0,
                    color: Colors.teal.shade100,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5
                  ),
                ),
              
              SizedBox(
                height: 20,
                child: Divider(
                  color: Colors.teal.shade100,
                ),
              ),

              Card( 
                color: Color.fromARGB(255, 247, 239, 239),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                  leading: 
                      Icon(
                        Icons.phone,
                        color: Colors.teal,
                        ),
                      title: 
                      Text(
                        '+84 9998 2322',
                        style: TextStyle(
                          color: Colors.teal,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20.0,
                          ),
                        )
                ),
              ),

              Card(
                color: Color.fromARGB(255, 247, 239, 239),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                    leading: Icon(
                        Icons.email,
                        color: Colors.teal,
                      ),
                      title:     Text(
                        'gonosen@gmail.com',
                        style: TextStyle(
                          color: Colors.teal,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20.0,
                          ),
                        ),
                  ))
            ],
          )),
      ),
    );
  }
}


