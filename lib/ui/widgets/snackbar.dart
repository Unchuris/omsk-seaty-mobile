
import 'package:flutter/material.dart';

SnackBar getSnackBarError(String message, BuildContext context) {
  return SnackBar(
    content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1
    ),
    backgroundColor: Theme.of(context).errorColor
  );
}
