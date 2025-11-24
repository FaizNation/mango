import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfilePhoto extends UseCase<String, UpdateProfilePhotoParams> {
  final ProfileRepository repository;

  UpdateProfilePhoto(this.repository);

  @override
  Future<String> call(UpdateProfilePhotoParams params) async {
    return await repository.updateProfilePhoto(params.imageBytes);
  }
}

class UpdateProfilePhotoParams extends Equatable {
  final Uint8List imageBytes;

  const UpdateProfilePhotoParams({required this.imageBytes});

  @override
  List<Object> get props => [imageBytes];
}
