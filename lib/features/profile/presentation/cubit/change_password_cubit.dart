import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/profile/domain/usecases/change_password.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePassword _changePassword;

  ChangePasswordCubit({required ChangePassword changePassword})
      : _changePassword = changePassword,
        super(const ChangePasswordState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));

    try {
      await _changePassword(ChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ));
      emit(state.copyWith(status: ChangePasswordStatus.success));
    } on ServerFailure catch (e) {
      emit(state.copyWith(
        status: ChangePasswordStatus.failure,
        error: e.message,
      ));
    }
  }
}
