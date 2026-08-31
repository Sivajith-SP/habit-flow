abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  bool get isLoggedIn;

  String? get currentUserEmail;

  String? get currentUserId;
}
