part of 'signup_cubit.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool obscurePassword;
  final String? userError;
  final String? emailError;
  final String? passError;
  final String? errorMessage;
  final bool isSuccess;

  const SignupState({
    required this.isLoading,
    required this.obscurePassword,
    required this.isSuccess,
    this.userError,
    this.emailError,
    this.passError,
    this.errorMessage,
  });

  const SignupState.initial()
      : isLoading = false,
        obscurePassword = true,
        isSuccess = false,
        userError = null,
        emailError = null,
        passError = null,
        errorMessage = null;

  SignupState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? userError,
    String? emailError,
    String? passError,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSuccess: isSuccess ?? this.isSuccess,
      userError: userError,
      emailError: emailError,
      passError: passError,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        obscurePassword,
        userError,
        emailError,
        passError,
        errorMessage,
        isSuccess,
      ];
}
