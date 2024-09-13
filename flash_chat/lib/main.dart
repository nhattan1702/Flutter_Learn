import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/blocs/auth_bloc/auth_bloc.dart';
import 'package:flash_chat/repositories/auth_repository.dart';
import 'package:flash_chat/screens/screens_chat/listchat_screen.dart';
import 'package:flash_chat/screens/splash_screen.dart';
import 'package:flash_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/screens_chat/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyDArot7IAaMetKcSGauOfmf3nhXYtCrn3s',
    appId: '1:873144144860:android:56a96755665bccbc76b519',
    messagingSenderId: 'sendid',
    projectId: 'flash-chat-523fc',
    storageBucket: 'flash-chat-523fc.appspot.com',
  ));
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(
              authService: AuthService(),
            ),
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black54),
          ),
        ),
        home: SplashScreen(),
        initialRoute: SplashScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          ListChatScreen.id: (context) => ListChatScreen(),
          SplashScreen.id: (context) => SplashScreen(),
        },
      ),
    );
  }
}
