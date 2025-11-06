import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mango/services/auth/auth_services.dart';


part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthService _auth;

  SignupCubit({AuthService? auth})
    : _auth = auth ?? AuthService(),
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
        successData: null,
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
      await _auth.signUpWithEmail(e, p, displayName: u);
      emit(
        state.copyWith(
          isLoading: false,
          successData: {'userName': u, 'userEmail': e, 'userPass': p},
        ),
      );
    } catch (err) {
      final message = err is Exception
          ? err.toString().replaceAll('Exception: ', '')
          : 'Registration failed';
      emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }
}
