import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gato_id_generator/src/domain/use_case/auth_usecase.dart';

import '../view/email_password_sign_in_form_type.dart';

part 'email_pass_sign_in_event.dart';
part 'email_pass_sign_in_state.dart';

class EmailPassSignInBloc extends Bloc<EmailPassSignInEvent, EmailPassSignInState> {
  final CreateUserWithEmailPasswUsecase _createUserWithEmailPasswUsecase;
  final SignInWithEmailPasswUsecase _signInWithEmailPasswUsecase;

  EmailPassSignInBloc(
    this._createUserWithEmailPasswUsecase,
    this._signInWithEmailPasswUsecase,
  ) : super(EmailPassSignInIdle()) {
    on<EmailPassSignInSubmit>(_authenticate);
  }

  Future<void> _authenticate(EmailPassSignInSubmit event, Emitter<EmailPassSignInState> emit) async {
    emit(EmailPassSignInLoading());

    try {
      if (event.formType == EmailPasswordSignInFormType.signIn) {
        await _signInWithEmailPasswUsecase.execute(event.email, event.passw);
      } else {
        await _createUserWithEmailPasswUsecase.execute(event.email, event.passw);
      }

      event.onSuccess();
      emit(EmailPassSignInIdle());
    } catch (e, st) {
      event.onError(e, st);
      emit(EmailPassSignInError());
    }
  }
}
