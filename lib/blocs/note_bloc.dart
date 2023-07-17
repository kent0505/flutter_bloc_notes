import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/http_requests.dart';
import '../models/note.dart';

// event
abstract class NoteEvent {}

class LoadNoteEvent extends NoteEvent {}

// state
abstract class NoteState {}

class NoteLoadingState extends NoteState {}

class NoteLoadedState extends NoteState {
  final List<Note> notes;
  NoteLoadedState(this.notes);
}

class NoteErrorState extends NoteState {
  final String error;
  NoteErrorState(this.error);
}

// bloc
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final ApiClient apiClient = ApiClient();

  NoteBloc() : super(NoteLoadingState()) {
    on<LoadNoteEvent>((event, emit) async {
      emit(NoteLoadingState());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token') ?? '';
        if (token != '') {
          final notes = await apiClient.getData(token);
          emit(NoteLoadedState(notes));
        }
      } catch (e) {
        print(e);
        emit(NoteErrorState('Error in backend!'));
      }
    });
  }
}
