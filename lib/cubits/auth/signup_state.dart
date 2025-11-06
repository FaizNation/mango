part of 'signup_cubit.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool obscurePassword;
  final String? userError;
  final String? emailError;
  final String? passError;
  final String? errorMessage;
  final Map<String, String>? successData;

  const SignupState({
    required this.isLoading,
    required this.obscurePassword,
    this.userError,
    this.emailError,
    this.passError,
    this.errorMessage,
    this.successData,
  });

  const SignupState.initial()
    : isLoading = false,
      obscurePassword = true,
      userError = null,
      emailError = null,
      passError = null,
      errorMessage = null,
      successData = null;

  SignupState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? userError,
    String? emailError,
    String? passError,
    String? errorMessage,
    Map<String, String>? successData,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      userError: userError,
      emailError: emailError,
      passError: passError,
      errorMessage: errorMessage,
      successData: successData ?? this.successData,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userError,
    emailError,
    passError,
    errorMessage,
    successData,
  ];
}
