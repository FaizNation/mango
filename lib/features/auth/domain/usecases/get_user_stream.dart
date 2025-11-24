import 'dart:async';
import 'package:mango/features/auth/domain/entities/user_entity.dart';
import 'package:mango/features/auth/domain/repositories/auth_repository.dart';

class GetUserStream {
  final AuthRepository repository;

  GetUserStream(this.repository);

  Stream<UserEntity?> call() {
    return repository.user;
  }
}
