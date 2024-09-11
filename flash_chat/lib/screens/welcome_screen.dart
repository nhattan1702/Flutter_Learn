import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../common/color.dart';
import '../components/slider_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors().default1, AppColors().default2],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Flash Chat',
                        textStyle: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textColor),
                        speed: const Duration(milliseconds: 500),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              // RoundedButton(
              //   title: 'Login',
              //   color: Colors.lightBlueAccent,
              //   onPressed: () {
              //     Navigator.pushNamed(context, LoginScreen.id);
              //   },
              // ),
              // RoundedButton(
              //   title: 'Register',
              //   color: Colors.blueAccent,
              //   onPressed: () {
              //     Navigator.pushNamed(context, RegistrationScreen.id);
              //   },
              // ),
              SliderButton(
                title: 'Get',
                routeName: LoginScreen.id,
              )
            ],
          ),
        ),
      ),
    );
  }
}
