import 'package:flutter/material.dart';

import '../pages/detail_page.dart';

class Navigations {
  void navigate(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
  }

  void editpage(BuildContext context, int id, String title, String desc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return DetailPage(
            id: id,
            title: title,
            desc: desc,
          );
        },
      ),
    );
  }

  void back(BuildContext context) {
    Navigator.pop(context);
  }
}
