part of 'login_cubit.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool obscurePassword;
  final String? emailError;
  final String? passError;
  final String? errorMessage;
  final Map<String, String>? successData;

  const LoginState({
    required this.isLoading,
    required this.obscurePassword,
    this.emailError,
    this.passError,
    this.errorMessage,
    this.successData,
  });

  const LoginState.initial()
    : isLoading = false,
      obscurePassword = true,
      emailError = null,
      passError = null,
      errorMessage = null,
      successData = null;

  LoginState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? emailError,
    String? passError,
    String? errorMessage,
    Map<String, String>? successData,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      emailError: emailError,
      passError: passError,
      errorMessage: errorMessage,
      successData: successData ?? this.successData,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    emailError,
    passError,
    errorMessage,
    successData,
  ];
}
