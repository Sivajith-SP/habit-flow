import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExceptionHandler {
  FirebaseAuthExceptionHandler._();

  static String getMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';

        case 'user-not-found':
          return 'No account found with this email.';

        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';

        case 'email-already-in-use':
          return 'An account with this email already exists.';

        case 'weak-password':
          return 'Password must be at least 6 characters.';

        case 'network-request-failed':
          return 'No internet connection. Please try again.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        default:
          return error.message ?? 'Authentication failed.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}