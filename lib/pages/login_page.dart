import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_bloc.dart';
import '../logic/navigations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginCon = TextEditingController();
  final passwordCon = TextEditingController();

  Navigations navigator = Navigations();

  @override
  void dispose() {
    loginCon.dispose();
    passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            // do stuff here based on LoginBloc's state
            if (state is LoginedState) {
              navigator.navigate(context, '/home');
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              // return widget here based on LoginBloc's state
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // this builder for error text
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginErrorState) {
                          return errorText(state.error);
                        } else {
                          return errorText('');
                        }
                      },
                    ),
                    usernameField(loginCon),
                    passwordField(passwordCon),
                    loginButton(() {
                      context.read<LoginBloc>().add(LoginButtonEvent(loginCon.text, passwordCon.text));
                      loginCon.clear();
                      passwordCon.clear();
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget errorText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget usernameField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Username',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget passwordField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      decoration: const InputDecoration(
        icon: Icon(Icons.security),
        hintText: 'Password',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget loginButton(VoidCallback func) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        onPressed: func,
        color: Colors.greenAccent,
        child: const Text('Login'),
      ),
    );
  }
}
