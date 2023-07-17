import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_bloc.dart';
import '../logic/alerts.dart';
import '../logic/navigations.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    Navigations navigator = Navigations();
    Alerts alert = Alerts();

    return BlocProvider(
      create: (context) => LoginBloc()..add(CheckNameEvent()),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is NameCheckedState) {
            return Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                state.name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Play',
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              Expanded(child: Container()),
                              IconButton(
                                onPressed: () {
                                  alert.showAlertDialog(context, 'Logout', () {
                                    context.read<LoginBloc>().add(LogoutButtonEvent());
                                    navigator.navigate(context, '/login');
                                  });
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Drawer();
        },
      ),
    );
  }
}
