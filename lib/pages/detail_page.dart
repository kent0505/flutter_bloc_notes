import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/detail_bloc.dart';
import '../logic/alerts.dart';
import '../logic/navigations.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
  });

  final int id;
  final String title;
  final String desc;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final titleCon = TextEditingController();
  final descCon = TextEditingController();

  Navigations navigator = Navigations();
  Alerts alert = Alerts();

  @override
  void initState() {
    titleCon.text = widget.title;
    descCon.text = widget.desc;
    super.initState();
  }

  @override
  void dispose() {
    titleCon.dispose();
    descCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return DetailBloc()..add(CheckEvent(titleCon.text, descCon.text));
      },
      child: BlocListener<DetailBloc, DetailState>(
        listener: (context, state) {
          if (state is ReturnBackState) {
            navigator.navigate(context, '/home');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              BlocBuilder<DetailBloc, DetailState>(
                builder: (context, state) {
                  if (state is EditPageState) {
                    return IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        alert.showAlertDialog(context, 'Delete', () {
                          context.read<DetailBloc>().add(
                                DeleteButtonEvent(widget.id),
                              );
                        });
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
          floatingActionButton: BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              if (state is EditPageState) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    context.read<DetailBloc>().add(EditButtonEvent(
                          widget.id,
                          titleCon.text,
                          descCon.text,
                        ));
                  },
                  label: const Text('Edit'),
                  icon: const Icon(Icons.save),
                );
              }

              if (state is AddPageState) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    context.read<DetailBloc>().add(SaveButtonEvent(
                          titleCon.text,
                          descCon.text,
                        ));
                  },
                  label: const Text('Save'),
                  icon: const Icon(Icons.save),
                );
              }

              return const SizedBox();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  titleTextField(titleCon),
                  descTextField(descCon),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget descTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      minLines: 10,
      maxLines: 1000,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: 'Type something...',
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget titleTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      enableSuggestions: false,
      autocorrect: false,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget floatingActionButton(String text, VoidCallback func) {
    return FloatingActionButton.extended(
      onPressed: func,
      label: Text(text),
      icon: const Icon(Icons.save),
    );
  }
}
