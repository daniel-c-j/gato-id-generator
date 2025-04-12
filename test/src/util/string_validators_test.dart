import 'package:flutter_test/flutter_test.dart';
import 'package:gato_id_generator/src/util/string_validators.dart';

void main() {
  group('EmailEditingRegexValidator', () {
    test('''
      Given an EmailEditingRegexValidator, 
      When isValid is called with a valid string, 
      Then it should return true.
    ''', () {
      // Arrange
      const emailValidator = EmailEditingRegexValidator();
      final validEmail = 'test@example.com';

      // Act
      final isValid = emailValidator.isValid(validEmail);

      // Assert
      expect(isValid, true);
    });

    test('''
      Given an EmailEditingRegexValidator, 
      When isValid is called with an empty string, 
      Then it should return true
    ''', () {
      // Arrange
      const emailValidator = EmailEditingRegexValidator();
      final emptyString = '';

      // Act
      final isValid = emailValidator.isValid(emptyString);

      // Assert
      expect(isValid, true);
    });

    test('''
      Given an EmailEditingRegexValidator, 
      When isValid is called with a non-matching string, 
      Then it should return false
    ''', () {
      // Arrange
      const emailValidator = EmailEditingRegexValidator();
      final invalidEmail = 'invalid @email';

      // Act
      final isValid = emailValidator.isValid(invalidEmail);

      // Assert
      expect(isValid, false);
    });
  });

  group('EmailSubmitRegexValidator', () {
    test('''
      Given a valid email address, 
      When isValid is called, 
      Then it should return true
    ''', () {
      // Arrange
      const emailValidator = EmailSubmitRegexValidator();
      final validEmail = 'test@example.com';

      // Act
      final isValid = emailValidator.isValid(validEmail);

      // Assert
      expect(isValid, true);
    });

    test('''
      Given an email address without "@" symbol, 
      When isValid is called, 
      Then it should return false
    ''', () {
      // Arrange
      const emailValidator = EmailSubmitRegexValidator();
      final invalidEmail = 'testexample.com';

      // Act
      final isValid = emailValidator.isValid(invalidEmail);

      // Assert
      expect(isValid, false);
    });

    test('''
      Given an email address without domain, 
      When isValid is called, 
      Then it should return false
    ''', () {
      // Arrange
      const emailValidator = EmailSubmitRegexValidator();
      final invalidEmail = 'test@.com';

      // Act
      final isValid = emailValidator.isValid(invalidEmail);

      // Assert
      expect(isValid, false);
    });

    test('''
      Given an email address without username, 
      When isValid is called, 
      Then it should return false
    ''', () {
      // Arrange
      const emailValidator = EmailSubmitRegexValidator();
      final invalidEmail = '@example.com';

      // Act
      final isValid = emailValidator.isValid(invalidEmail);

      // Assert
      expect(isValid, false);
    });

    test('''
      Given an empty string, 
      When isValid is called, 
      Then it should return false
    ''', () {
      // Arrange
      const emailValidator = EmailSubmitRegexValidator();
      final emptyString = '';

      // Act
      final isValid = emailValidator.isValid(emptyString);

      // Assert
      expect(isValid, false);
    });
  });

  group('NonEmptyStringValidator', () {
    test('''
      Given a NonEmptyStringValidator, 
      When isValid is called with a non-empty string, 
      Then it should return true
    ''', () {
      // Arrange
      const validator = NonEmptyStringValidator();
      final nonEmptyString = 'Hello';

      // Act
      final isValid = validator.isValid(nonEmptyString);

      // Assert
      expect(isValid, true);
    });

    test('''
      Given a NonEmptyStringValidator, 
      When isValid is called with an empty string, 
      Then it should return false
    ''', () {
      // Arrange
      const validator = NonEmptyStringValidator();
      final emptyString = '';

      // Act
      final isValid = validator.isValid(emptyString);

      // Assert
      expect(isValid, false);
    });
  });

  group('MinLengthStringValidator', () {
    test('''
      Given a MinLengthStringValidator with minLength 5, 
      When isValid is called with a string of sufficient length, 
      Then it should return true
    ''', () {
      // Arrange
      const validator = MinLengthStringValidator(5);
      final validString = 'HelloWorld';

      // Act
      final isValid = validator.isValid(validString);

      // Assert
      expect(isValid, true);
    });

    test('''
      Given a MinLengthStringValidator with minLength 5, 
      When isValid is called with a string shorter than minLength, 
      Then it should return false
    ''', () {
      // Arrange
      const validator = MinLengthStringValidator(5);
      final shortString = 'Hi';

      // Act
      final isValid = validator.isValid(shortString);

      // Assert
      expect(isValid, false);
    });

    test('''
      Given a MinLengthStringValidator with minLength 0, 
      When isValid is called with an empty string, 
      Then it should return true
    ''', () {
      // Arrange
      const validator = MinLengthStringValidator(0);
      final emptyString = '';

      // Act
      final isValid = validator.isValid(emptyString);

      // Assert
      expect(isValid, true);
    });
  });
}
