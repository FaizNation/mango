import 'package:mango/core/usecase/usecase.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';

class SignOut extends UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.signOut();
  }
}
