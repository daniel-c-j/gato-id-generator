// coverage:ignore-file
import 'package:flutter/material.dart';

import '../../util/context_shortcut.dart';

Future<void> showTextSnackBar(BuildContext context, {required String txt}) async {
  kSnackBar(context).clearSnackBars();
  kSnackBar(context).showSnackBar(
    SnackBar(
      content: Text(txt),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

Future<void> showErrorSnackBar(BuildContext context, {Object? error}) async {
  kSnackBar(context).clearSnackBars();
  kSnackBar(context).showSnackBar(
    SnackBar(
      content: Text("Error: ${error.toString()}"),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

Future<void> showUnimplementedSnackBar(BuildContext context) async {
  kSnackBar(context).clearSnackBars();
  kSnackBar(context).showSnackBar(
    SnackBar(
      content: Text("Sorry, not implemented yet!"),
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
