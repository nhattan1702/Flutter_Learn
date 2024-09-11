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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          // else {
                          //   return _emailError;
                          // }
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
                          // else {
                          //   return _passwordError;
                          // }
                        },
                      ),
                      SizedBox(height: 24.0),
                      SizedBox(height: 24.0),
                      RoundedButton(
                        title: 'Register',
                        color: Colors.blueAccent,
                        onPressed: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  RegisterUserEvent(
                                    email: email,
                                    password: password,
                                    // image: _imageFile!,
                                  ),
                                );
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            LoginScreen.id,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Bạn đã có tài khoản? Đăng Nhập"),
                            ),
                          ],
                        ),
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
