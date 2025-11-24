import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/auth/domain/usecases/sign_up_with_email.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignUpWithEmail _signUpWithEmail;

  SignupCubit({required SignUpWithEmail signUpWithEmail})
      : _signUpWithEmail = signUpWithEmail,
        super(const SignupState.initial());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> submit(String user, String email, String pass) async {
    emit(
      state.copyWith(
        isLoading: true,
        userError: null,
        emailError: null,
        passError: null,
        errorMessage: null,
        isSuccess: false,
      ),
    );

    final u = user.trim();
    final e = email.trim();
    final p = pass.trim();

    String? userErr;
    String? emailErr;
    String? passErr;
    if (u.isEmpty) userErr = 'User wajib diisi';
    if (e.isEmpty) emailErr = 'Email wajib diisi';
    if (p.isEmpty) passErr = 'Password wajib diisi';
    if (userErr != null || emailErr != null || passErr != null) {
      emit(
        state.copyWith(
          isLoading: false,
          userError: userErr,
          emailError: emailErr,
          passError: passErr,
        ),
      );
      return;
    }

    try {
      await _signUpWithEmail(
          SignUpParams(email: e, password: p, displayName: u));
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on ServerFailure catch (err) {
      emit(state.copyWith(isLoading: false, errorMessage: err.message));
    }
  }
}
