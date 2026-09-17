abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> updateUserName(String name);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({
    required String password,
  });

  bool get isLoggedIn;

  String? get currentUserEmail;

  String? get currentUserId;

  String? get currentUserDisplayName;
}
