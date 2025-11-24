import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/profile/domain/usecases/update_profile_photo.dart';
import 'package:mango/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateProfilePhoto _updateProfilePhoto;

  ProfileCubit({required UpdateProfilePhoto updateProfilePhoto})
      : _updateProfilePhoto = updateProfilePhoto,
        super(const ProfileState());

  Future<void> updatePhoto(Uint8List imageBytes) async {
    emit(state.copyWith(photoUpdateStatus: PhotoUpdateStatus.loading));
    try {
      final newUrl = await _updateProfilePhoto(UpdateProfilePhotoParams(imageBytes: imageBytes));
      emit(state.copyWith(
        photoUpdateStatus: PhotoUpdateStatus.success,
        newPhotoUrl: newUrl,
      ));
    } on ServerFailure catch (e) {
      emit(state.copyWith(
        photoUpdateStatus: PhotoUpdateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }
}
