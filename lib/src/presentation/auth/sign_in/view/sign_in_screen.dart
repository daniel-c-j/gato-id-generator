import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/_constants.dart';
import 'email_password_sign_in_form_type.dart';
import 'email_password_sign_in_validators.dart';
import 'string_validators.dart';

/// Email & password sign in screen.
/// Wraps the [EmailPasswordSignInContents] widget below with a [Scaffold] and
/// [AppBar] with a title.
class EmailPasswordSignInScreen extends StatelessWidget {
  const EmailPasswordSignInScreen({super.key, required this.formType});
  final EmailPasswordSignInFormType formType;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In'.tr())),
      body: EmailPasswordSignInContents(
        formType: formType,
      ),
    );
  }
}

/// A widget for email & password authentication, supporting the following:
/// - sign in
/// - register (create an account)
class EmailPasswordSignInContents extends StatefulWidget {
  const EmailPasswordSignInContents({
    super.key,
    this.onSignedIn,
    required this.formType,
  });
  final VoidCallback? onSignedIn;

  /// The default form type to use.
  final EmailPasswordSignInFormType formType;
  @override
  State<EmailPasswordSignInContents> createState() => _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState extends State<EmailPasswordSignInContents>
    with EmailAndPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  bool _submitted = false;
  // track the formType as a local state variable
  late var _formType = widget.formType;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      // final controller = ref.read(emailPasswordSignInControllerProvider.notifier);
      // final success = await controller.submit(
      //   email: email,
      //   password: password,
      //   formType: _formType,
      // );

      // if (success) widget.onSignedIn?.call();
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType() {
    // * Toggle between register and sign in form
    setState(() => _formType = _formType.secondaryActionFormType);
    // * Clear the password field when doing so
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<AsyncValue>(
    //   emailPasswordSignInControllerProvider,
    //   (_, state) => state.showAlertDialogOnError(context),
    // );
    // final state = ref.watch(emailPasswordSignInControllerProvider);
    return Container(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GAP_H8,
              // Email field
              TextFormField(
                key: EmailPasswordSignInScreen.emailKey,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email'.tr(),
                  hintText: 'test@test.com'.tr(),
                  // enabled: !state.isLoading, // TODO
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => !_submitted ? null : emailErrorText(email ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator()),
                ],
              ),
              GAP_H8,
              // Password field
              TextFormField(
                key: EmailPasswordSignInScreen.passwordKey,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: _formType.passwordLabelText,
                  // enabled: !state.isLoading, // TODO
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => !_submitted ? null : passwordErrorText(password ?? '', _formType),
                obscureText: true,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _passwordEditingComplete(),
              ),
              GAP_H8, // TODO
              // PrimaryButton(
              //   text: _formType.primaryButtonText,
              //   isLoading: state.isLoading,
              //   onPressed: state.isLoading ? null : () => _submit(),
              // ),
              GAP_H8,
              // CustomTextButton(
              //   text: _formType.secondaryButtonText,
              //   onPressed: state.isLoading ? null : _updateFormType,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
