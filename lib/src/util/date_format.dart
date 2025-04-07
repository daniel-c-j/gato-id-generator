import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  static final _formatter = DateFormat('dd-MM-yyyy');

  String get formatTime => _formatter.format(this);
}
