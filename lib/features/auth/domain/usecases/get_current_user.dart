import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/auth/domain/entities/user_entity.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser extends UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<UserEntity?> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
