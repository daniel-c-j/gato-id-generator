import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/util/date_format.dart';
import 'package:intl/intl.dart';

void main() {
  test('''
    Given a DateTime object, 
    When formatTime is called, 
    Then it should return the date in dd-MM-yyyy format
      ''', () {
    // * Arrange
    final dateTime = DateTime(2023, 10, 5); // Example date: 5th October 2023
    final expectedFormattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    // * Act
    final formattedDate = dateTime.formatTime;

    // * Assert
    expect(formattedDate, expectedFormattedDate);
  });
}
