import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';
import '../common/color.dart';
import '../components/rounded_button.dart';
import '../common/constants.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreRepository _firestoreRepository = FirestoreRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool otpSent = false;
  String verificationId = '';
  bool otpVerified = false;

  void sendOTP() async {
    await _firestoreRepository.sendOTP(
      phoneNumber: _phoneController.text.trim(),
      onCodeSent: (String verId) {
        setState(() {
          verificationId = verId;
          otpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP đã được gửi đến số điện thoại của bạn')),
        );
      },
      onVerificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Số điện thoại không hợp lệ')),
          );
        }
      },
    );
  }

  void verifyOTP() async {
    final bool isVerified = await _firestoreRepository.verifyOTP(
      verificationId: verificationId,
      smsCode: _otpController.text.trim(),
    );
    if (isVerified) {
      setState(() {
        otpVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP đúng, tiếp tục đăng ký')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP không đúng, thử lại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().default1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors().default1,
              AppColors().default2,
            ],
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng Ký thành công')),
              );
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is AuthLoading,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Flexible(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            height: 200.0,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                      ),
                      SizedBox(height: 48.0),
                      TextFormField(
                        controller: _phoneController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        decoration: kTestFieldDecoration.copyWith(
                          hintText: 'Enter your phone number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Không được để trống số điện thoại';
                          }
                          return null;
                        },
                      ),
                      if (otpSent)
                        Column(
                          children: [
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _otpController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: kTestFieldDecoration.copyWith(
                                hintText: 'Enter OTP',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Không được để trống OTP';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8.0),
                            RoundedButton(
                              title: 'Verify OTP',
                              color: Colors.greenAccent,
                              onPressed: verifyOTP,
                            ),
                          ],
                        ),
                      SizedBox(height: 8.0),
                      if (!otpSent)
                        RoundedButton(
                          title: 'Send OTP',
                          color: Colors.blueAccent,
                          onPressed: sendOTP,
                        ),
                      if (otpVerified)
                        Column(
                          children: [
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _emailController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.emailAddress,
                              decoration: kTestFieldDecoration.copyWith(
                                hintText: 'Enter your email',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Không được để trống email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordController,
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: kTestFieldDecoration.copyWith(
                                  hintText: 'Enter your password',
                                  errorStyle: TextStyle(color: Colors.red)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Không được để trống mật khẩu';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.0),
                            RoundedButton(
                              title: 'Register',
                              color: Colors.blueAccent,
                              onPressed: () {
                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        RegisterUserEvent(
                                          email: email,
                                          password: password,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
