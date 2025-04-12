// coverage:ignore-file
import 'package:easy_localization/easy_localization.dart';

import '../presentation/auth/sign_in/view/email_password_sign_in_form_type.dart';
import 'string_validators.dart';

/// Mixin class to be used for client-side email & password validation
mixin EmailAndPasswordValidators {
  static const StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  static const StringValidator passwordRegisterSubmitValidator = MinLengthStringValidator(8);
  static const StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();

  bool canSubmitEmail(String email) => emailSubmitValidator.isValid(email);

  bool canSubmitPassword(String password, EmailPasswordSignInFormType formType) {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final showErrorText = !canSubmitEmail(email);
    final errorText = (email.isEmpty) ? "Email cannot be empty".tr() : 'Invalid email'.tr();
    return (showErrorText) ? errorText : null;
  }

  String? passwordErrorText(String password, EmailPasswordSignInFormType formType) {
    final showErrorText = !canSubmitPassword(password, formType);
    final errorText = (password.isEmpty) ? "Password cannot be empty".tr() : 'Password is too short'.tr();
    return (showErrorText) ? errorText : null;
  }
}
