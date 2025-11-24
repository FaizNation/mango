import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/auth/domain/usecases/sign_in_with_email.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final SignInWithEmail _signInWithEmail;

  LoginCubit({required SignInWithEmail signInWithEmail})
      : _signInWithEmail = signInWithEmail,
        super(const LoginState.initial());

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> submit(String email, String pass) async {
    emit(
      state.copyWith(
        isLoading: true,
        emailError: null,
        passError: null,
        errorMessage: null,
        isSuccess: false,
      ),
    );

    final e = email.trim();
    final p = pass.trim();

    String? emailErr;
    String? passErr;
    if (e.isEmpty) emailErr = 'Email wajib diisi';
    if (p.isEmpty) passErr = 'Password wajib diisi';
    if (emailErr != null || passErr != null) {
      emit(
        state.copyWith(
          isLoading: false,
          emailError: emailErr,
          passError: passErr,
        ),
      );
      return;
    }

    try {
      await _signInWithEmail(SignInParams(email: e, password: p));
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on ServerFailure catch (err) {
      emit(state.copyWith(isLoading: false, errorMessage: err.message));
    }
  }
}
