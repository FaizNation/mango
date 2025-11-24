import 'package:equatable/equatable.dart';

enum PhotoUpdateStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final PhotoUpdateStatus photoUpdateStatus;
  final String? newPhotoUrl;
  final String? errorMessage;

  const ProfileState({
    this.photoUpdateStatus = PhotoUpdateStatus.initial,
    this.newPhotoUrl,
    this.errorMessage,
  });

  ProfileState copyWith({
    PhotoUpdateStatus? photoUpdateStatus,
    String? newPhotoUrl,
    String? errorMessage,
  }) {
    return ProfileState(
      photoUpdateStatus: photoUpdateStatus ?? this.photoUpdateStatus,
      newPhotoUrl: newPhotoUrl ?? this.newPhotoUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [photoUpdateStatus, newPhotoUrl, errorMessage];
}
