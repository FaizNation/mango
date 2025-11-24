import 'dart:typed_data';
import 'package:mango/core/error/exceptions.dart';
import 'package:mango/core/error/failure.dart';
import 'package:mango/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mango/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<String> updateProfilePhoto(Uint8List imageBytes) async {
    try {
      return await remoteDataSource.updateProfilePhoto(imageBytes);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
