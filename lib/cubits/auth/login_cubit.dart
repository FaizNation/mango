import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango/services/auth/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _auth;

  LoginCubit({AuthService? auth})
    : _auth = auth ?? AuthService(),
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
        successData: null,
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
      final cred = await _auth.signInWithEmail(e, p);
      final user = cred.user;

      String userName = '';
      if (user != null) {
        userName = user.displayName ?? '';
        if (userName.isEmpty) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            if (doc.exists) {
              final data = doc.data();
              if (data != null && data['displayName'] != null) {
                userName = data['displayName'] as String;
              }
            }
          } catch (_) {}
        }
      }
      if (userName.isEmpty) userName = e;

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      await prefs.setString('userEmail', e);

      emit(
        state.copyWith(
          isLoading: false,
          successData: {'userName': userName, 'userEmail': e, 'userPass': p},
        ),
      );
    } catch (err) {
      final message = err is Exception
          ? err.toString().replaceAll('Exception: ', '')
          : 'Login failed';
      emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }
}
