import 'package:flutter/material.dart';

class Alerts {
  showAlertDialog(BuildContext context, String text, VoidCallback yes) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'Cancel',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    Widget continueButton = TextButton(
      onPressed: yes,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$text?'),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }
}
