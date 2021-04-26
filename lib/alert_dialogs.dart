import 'package:flutter/material.dart';

class AlertDialogs {
  static AlertDialog areYouSure(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Text("Do you really want to leave? The group will be deleted if you are the admin."),
      actions: [
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }

  static AlertDialog connectionError(BuildContext context) {
    return AlertDialog(
      title: Text("Connection error"),
      content: Text("Can't connect to the admin. Wait a few seconds, or try to start a new game."),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
