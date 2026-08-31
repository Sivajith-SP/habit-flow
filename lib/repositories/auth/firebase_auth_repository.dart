import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  @override
  String? get currentUserEmail => _firebaseAuth.currentUser?.email;

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;


  // login()
  @override
  Future<void> login({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // register()
  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // logout()
  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
