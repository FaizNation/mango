import 'package:equatable/equatable.dart';

// Enum untuk status load halaman utama
enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  // Status untuk page load
  final ProfileStatus status;
  final String? error;
  
  // Data utama
  final String? photoUrl;
  
  // State UI (menggantikan _loading)
  final bool isDialogLoading;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.error,
    this.photoUrl,
    this.isDialogLoading = false, // Default adalah false
  });

  // copyWith untuk update state
  ProfileState copyWith({
    ProfileStatus? status,
    String? error,
    String? photoUrl,
    bool? isDialogLoading,
  }) {
    return ProfileState(
      status: status ?? this.status,
      error: error ?? this.error,
      photoUrl: photoUrl ?? this.photoUrl,
      isDialogLoading: isDialogLoading ?? this.isDialogLoading,
    );
  }
  
  @override
  List<Object?> get props => [status, error, photoUrl, isDialogLoading];
}