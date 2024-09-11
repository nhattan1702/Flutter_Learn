import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/screens_chat/listchat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../components/rounded_button.dart';
import '../common/color.dart';
import '../common/constants.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacementNamed(context, ListChatScreen.id);
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Không được để trống email';
                              }
                              return null;
                            },
                            controller: _emailController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            decoration: kTestFieldDecoration.copyWith(
                                hintText: 'Enter your email',
                                errorStyle: TextStyle(color: Colors.red)),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Không được để trống mật khẩu';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration: kTestFieldDecoration.copyWith(
                                hintText: 'Enter your password',
                                errorStyle: TextStyle(color: Colors.red)),
                          ),
                          SizedBox(height: 24.0),
                          RoundedButton(
                            title: 'Log in',
                            color: Colors.blueAccent,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      LoginUserEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                              }
                              ;
                            },
                          ),
                          SizedBox(height: 12.0),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, RegistrationScreen.id);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Bạn chưa có tài khoản? Đăng Ký"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )));
          },
        ),
      ),
    );
  }
}
