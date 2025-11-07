import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ProfileCubit({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(const ProfileState()); // Mulai dengan state default

  Future<void> loadCurrentPhoto() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final user = _auth.currentUser;
    if (user == null) {
      emit(state.copyWith(status: ProfileStatus.error, error: "No user logged in"));
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data();
      final photo = data != null ? data['photoUrl'] as String? : null;
      
      emit(state.copyWith(
        status: ProfileStatus.success,
        photoUrl: photo ?? user.photoURL,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.success, // Tetap success, hanya fallback
        photoUrl: user.photoURL,
      ));
    }
  }

  // Dipanggil saat editor foto memberikan URL baru
  void setPhotoUrl(String newUrl) {
    emit(state.copyWith(photoUrl: newUrl));
  }

  // Dipanggil saat tombol edit (pensil) ditekan
  void startDialogLoading() {
    emit(state.copyWith(isDialogLoading: true));
  }
  
  // Dipanggil di 'finally' block pada dialog
  void stopDialogLoading() {
    emit(state.copyWith(isDialogLoading: false));
  }
}