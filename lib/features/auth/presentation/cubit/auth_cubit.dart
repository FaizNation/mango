import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mango/features/auth/domain/entities/user_entity.dart';
import 'package:mango/features/auth/domain/usecases/get_user_stream.dart';
import 'package:mango/features/auth/domain/usecases/sign_out.dart';
import 'package:mango/core/usecase/usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetUserStream _getUserStream;
  final SignOut _signOut;
  StreamSubscription<UserEntity?>? _userSubscription;

  AuthCubit({required GetUserStream getUserStream, required SignOut signOut})
    : _getUserStream = getUserStream,
      _signOut = signOut,
      super(const AuthState.unknown()) {
    _monitorUser();
  }

  void _monitorUser() {
    _userSubscription = _getUserStream().listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signOut() async {
    await _signOut(NoParams());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
