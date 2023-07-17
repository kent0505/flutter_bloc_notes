import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/http_requests.dart';

// event
abstract class LoginEvent {}

class LoginCheckEvent extends LoginEvent {}

class LoginButtonEvent extends LoginEvent {
  final String login;
  final String password;
  LoginButtonEvent(this.login, this.password);
}

class LogoutButtonEvent extends LoginEvent {}

class CheckNameEvent extends LoginEvent {}

// state
abstract class LoginState {}

class LoginingState extends LoginState {}

class LoginedState extends LoginState {
  final String token;
  LoginedState(this.token);
}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}

class NameCheckedState extends LoginState {
  final String name;
  NameCheckedState(this.name);
}

// bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiClient apiClient = ApiClient();

  LoginBloc() : super(LoginingState()) {
    on<LoginCheckEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        bool hasExpired = JwtDecoder.isExpired(token);
        if (token != '' && hasExpired == false) {
          emit(LoginedState(token));
        } else {
          emit(LoginingState());
        }
      } catch (e) {
        print(e);
        emit(LoginErrorState(e.toString()));
      }
    });

    on<LoginButtonEvent>((event, emit) async {
      emit(LoginingState());
      try {
        if (event.login == '' || event.password == '') {
          emit(LoginErrorState('Username or password not entered!'));
          return;
        }
        final token = await apiClient.loginResponse(
          event.login,
          event.password,
        );
        if (token != '') {
          emit(LoginedState(token));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('name', event.login);
        } else {
          emit(LoginErrorState('Username or password invalid!'));
        }
      } catch (e) {
        print(e);
        emit(LoginErrorState('Error in backend!'));
      }
    });

    on<LogoutButtonEvent>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        await apiClient.logoutResponse(token);
        await prefs.setString('token', '');
        emit(LoginingState());
      } catch (e) {
        print(e);
      }
    });

    on<CheckNameEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name') ?? '';
      emit(NameCheckedState(name));
    });
  }
}
