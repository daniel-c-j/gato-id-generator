import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gato_id_generator/src/core/routing/app_router.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/custom_button.dart';
import 'package:gato_id_generator/src/presentation/_common_widgets/hud_overlay.dart';
import 'package:gato_id_generator/src/presentation/auth/sign_in/bloc/email_pass_sign_in_bloc.dart';
import 'package:gato_id_generator/src/util/context_shortcut.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/_core.dart';
import '../../../../core/constants/_constants.dart';
import 'email_password_sign_in_form_type.dart';
import '../../../../util/email_password_sign_in_validators.dart';
import '../../../../util/string_validators.dart';

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
      appBar: AppBar(
        title: Text('Sign In'.tr()),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
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
    required this.formType,
  });

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
      final event = EmailPassSignInSubmit(
        email: email,
        passw: password,
        formType: _formType,
        onSuccess: () async {
          if (_formType == EmailPasswordSignInFormType.register) {
            kSnackBar(context).clearSnackBars();
            kSnackBar(context).showSnackBar(
              SnackBar(
                content: Text("One more step! Sign-in and you're good to go."),
                dismissDirection: DismissDirection.horizontal,
              ),
            );
            return _updateFormType();
          }

          return context.goNamed(AppRoute.generate.name);
        },
        onError: (e, st) {
          kSnackBar(context).clearSnackBars();
          kSnackBar(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${e.toString()}"),
              dismissDirection: DismissDirection.horizontal,
            ),
          );
        },
      );

      context.read<EmailPassSignInBloc>().add(event);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: BlocBuilder<EmailPassSignInBloc, EmailPassSignInState>(
            builder: (context, state) {
              // Controlling HUD
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (state is EmailPassSignInLoading) return context.read<HudControllerCubit>().show();
                context.read<HudControllerCubit>().hide();
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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
                              enabled: state is! EmailPassSignInLoading,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (email) => (!_submitted) ? null : emailErrorText(email ?? ''),
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onEditingComplete: () => _emailEditingComplete(),
                            inputFormatters: const [
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
                              enabled: state is! EmailPassSignInLoading,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (password) =>
                                (!_submitted) ? null : passwordErrorText(password ?? '', _formType),
                            obscureText: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () => _passwordEditingComplete(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CustomButton(
                        msg: _formType.secondaryButtonText,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        onTap: () {
                          (state is EmailPassSignInLoading) ? null : _updateFormType();
                        },
                        child: Text(_formType.secondaryButtonText),
                      ),
                    ),
                  ),
                  GAP_H8,
                  Builder(builder: (context) {
                    final isLight = context.watch<PlatformBrightnessBloc>().state == Brightness.light;

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: (isLight)
                              ? const [
                                  PRIMARY_COLOR_L0,
                                  PRIMARY_COLOR_L1,
                                  PRIMARY_COLOR_L2,
                                ]
                              : const [
                                  PRIMARY_COLOR_D0,
                                  PRIMARY_COLOR_D1,
                                  PRIMARY_COLOR_D2,
                                ],
                        ),
                      ),
                      child: CustomButton(
                        msg: _formType.primaryButtonText,
                        buttonColor: Colors.transparent,
                        onTap: () {
                          (state is EmailPassSignInLoading) ? null : _submit();
                        },
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            _formType.primaryButtonText,
                            textAlign: TextAlign.center,
                            style: kTextStyle(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
                  GAP_H12,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
