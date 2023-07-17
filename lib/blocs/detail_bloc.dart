import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/http_requests.dart';

// event
abstract class DetailEvent {}

class CheckEvent extends DetailEvent {
  final String title;
  final String desc;
  CheckEvent(this.title, this.desc);
}

class DeleteButtonEvent extends DetailEvent {
  final int id;
  DeleteButtonEvent(this.id);
}

class EditButtonEvent extends DetailEvent {
  final int id;
  final String title;
  final String desc;
  EditButtonEvent(this.id, this.title, this.desc);
}

class SaveButtonEvent extends DetailEvent {
  final String title;
  final String desc;
  SaveButtonEvent(this.title, this.desc);
}

// state
abstract class DetailState {}

class DetailInitial extends DetailState {}

class EditPageState extends DetailState {}

class AddPageState extends DetailState {}

class ReturnBackState extends DetailState {}

// bloc
class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final ApiClient apiClient = ApiClient();

  DetailBloc() : super(DetailInitial()) {
    on<CheckEvent>((event, emit) {
      if (event.title == '' && event.desc == '') {
        emit(AddPageState());
      } else {
        emit(EditPageState());
      }
    });

    on<SaveButtonEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      if (token != '') {
        await apiClient.addData(event.title, event.desc, token);
        emit(ReturnBackState());
      }
    });

    on<EditButtonEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      if (token != '') {
        await apiClient.putData(event.id, event.title, event.desc, token);
        emit(ReturnBackState());
      }
    });

    on<DeleteButtonEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      if (token != '') {
        await apiClient.deleteData(event.id, token);
        emit(ReturnBackState());
      }
    });
  }
}
