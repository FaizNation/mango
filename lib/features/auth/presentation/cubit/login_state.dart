part of 'login_cubit.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool obscurePassword;
  final String? emailError;
  final String? passError;
  final String? errorMessage;
  final bool isSuccess;

  const LoginState({
    required this.isLoading,
    required this.obscurePassword,
    required this.isSuccess,
    this.emailError,
    this.passError,
    this.errorMessage,
  });

  const LoginState.initial()
      : isLoading = false,
        obscurePassword = true,
        isSuccess = false,
        emailError = null,
        passError = null,
        errorMessage = null;

  LoginState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? emailError,
    String? passError,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSuccess: isSuccess ?? this.isSuccess,
      emailError: emailError,
      passError: passError,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        obscurePassword,
        emailError,
        passError,
        errorMessage,
        isSuccess,
      ];
}
