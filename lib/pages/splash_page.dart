import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_bloc.dart';
import '../logic/navigations.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Navigations navigator = Navigations();

    return BlocProvider(
      create: (context) => LoginBloc()..add(LoginCheckEvent()),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginedState) {
              Future.delayed(const Duration(seconds: 2), () {
                navigator.navigate(context, '/home');
              });
            } else {
              Future.delayed(const Duration(seconds: 2), () {
                navigator.navigate(context, '/login');
              });
            }
          },
          child: const Center(child: Text('Splash')),
        ),
      ),
    );
  }
}
