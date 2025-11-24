part of 'change_password_cubit.dart';

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final String? error;
  final bool isObscure;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.error,
    this.isObscure = true,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? error,
    bool? isObscure,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      error: error ?? this.error,
      isObscure: isObscure ?? this.isObscure,
    );
  }

  @override
  List<Object?> get props => [status, error, isObscure];
}
