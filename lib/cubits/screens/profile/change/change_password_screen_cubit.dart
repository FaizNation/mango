import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'change_password_screen_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final FirebaseAuth _auth;

  // Mulai dengan state default
  ChangePasswordCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(const ChangePasswordState());

  // FUNGSI BARU UNTUK UI:
  void togglePasswordVisibility() {
    // Emit state baru hanya dengan mengubah nilai isObscure
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  // FUNGSI LAMA (Logika Bisnis) yang disesuaikan:
  Future<void> updatePassword(String currentPassword, String newPassword) async {
    // Emit state Loading
    emit(state.copyWith(status: ChangePasswordStatus.loading));

    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        emit(state.copyWith(
          status: ChangePasswordStatus.failure,
          error: "No user is currently logged in.",
        ));
        return;
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword.trim());

      // Emit Success
      emit(state.copyWith(status: ChangePasswordStatus.success));

    } on FirebaseAuthException catch (e) {
      // Emit Failure
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        error: e.message ?? "An unknown auth error occurred.",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        error: "An unexpected error occurred: $e",
      ));
    }
  }
}