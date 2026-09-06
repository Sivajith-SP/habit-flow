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

  @override
  String? get currentUserDisplayName =>
      _firebaseAuth.currentUser?.displayName;

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

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

  @override
  Future<void> updateUserName(String name) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found');
    }

    await user.updateDisplayName(name);
    await user.reload();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found');
    }

    final email = user.email;

    if (email == null) {
      throw Exception('No email found for authenticated user');
    }

    // Re-authenticate before changing password.
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // Change password.
    await user.updatePassword(newPassword);
  }

  @override
  Future<void> deleteAccount({
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found');
    }

    final email = user.email;

    if (email == null) {
      throw Exception('No email found for authenticated user');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    // Firebase requires recent authentication
    await user.reauthenticateWithCredential(credential);

    // Delete Firebase account
    await user.delete();
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}