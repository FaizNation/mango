import 'package:equatable/equatable.dart';

// Enum untuk status, menggantikan kelas-kelas state
enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState extends Equatable {
  // 1. Properti untuk status proses
  final ChangePasswordStatus status;
  final String? error;

  // 2. Properti untuk state UI yang kita pindahkan
  final bool isObscure;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.error,
    this.isObscure = true, // Nilai default
  });

  // 3. Buat copyWith untuk mempermudah emit state baru
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