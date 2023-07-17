import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/note_bloc.dart';
import '../logic/navigations.dart';
import './drawer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Navigations navigator = Navigations();

    return BlocProvider<NoteBloc>(
      create: (context) => NoteBloc()..add(LoadNoteEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: const DrawerPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigator.editpage(context, 0, '', '');
          },
          child: const Icon(Icons.edit),
        ),
        body: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            if (state is NoteLoadingState) {
              return const Center(child: Text('Loading...'));
            }
            if (state is NoteErrorState) {
              return Center(child: Text(state.error));
            }
            if (state is NoteLoadedState) {
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.notes[index].title),
                    subtitle: Text(state.notes[index].desc),
                    onTap: () {
                      navigator.editpage(
                        context,
                        state.notes[index].id,
                        state.notes[index].title,
                        state.notes[index].desc,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
