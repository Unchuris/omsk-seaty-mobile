import 'package:flutter/material.dart';

SnackBar getSnackBarError(String message, BuildContext context) {
  return SnackBar(
    content: Text(message,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Colors.white)),
    backgroundColor: Theme.of(context).errorColor,
    behavior: SnackBarBehavior.floating,
  );
}
