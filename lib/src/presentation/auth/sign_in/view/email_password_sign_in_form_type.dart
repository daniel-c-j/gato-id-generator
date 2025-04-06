import 'package:easy_localization/easy_localization.dart';

/// Form type for email & password authentication
enum EmailPasswordSignInFormType { signIn, register }

extension EmailPasswordSignInFormTypeX on EmailPasswordSignInFormType {
  String get passwordLabelText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Password (8+ characters)'.tr();
    } else {
      return 'Password'.tr();
    }
  }

  // Getters
  String get primaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Create an account'.tr();
    } else {
      return 'Sign in'.tr();
    }
  }

  String get secondaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Have an account? Sign in'.tr();
    } else {
      return 'Need an account? Register'.tr();
    }
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    if (this == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInFormType.signIn;
    } else {
      return EmailPasswordSignInFormType.register;
    }
  }

  String get errorAlertTitle {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Registration failed'.tr();
    } else {
      return 'Sign in failed'.tr();
    }
  }

  String get title {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Register'.tr();
    } else {
      return 'Sign in'.tr();
    }
  }
}
