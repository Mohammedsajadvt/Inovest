import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inovest/core/utils/user_utils.dart';
import 'package:inovest/data/models/auth_model.dart';
import 'package:inovest/data/services/auth_service.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  Future<AuthModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase.UserCredential authResult = 
          await _auth.signInWithCredential(credential);
      final firebase.User? user = authResult.user;

      if (user != null) {
        final AuthModel? response = await _authService.googleLogin(
          email: user.email ?? '',
          name: user.displayName ?? '',
          googleId: user.uid,
        );

        if (response != null && response.success) {
          final accessToken = response.data?.tokens.accessToken ?? "";
          final userRole = response.data?.user.role ?? "GUEST";
          final userId = response.data?.user.id ?? "";

          if (accessToken.isNotEmpty) {
            await UserUtils.saveUserData(
              token: accessToken,
              role: userRole,
              userId: userId,
            );
          }
        }
        return response;
      }
      return null;
    } catch (error) {
      print("Google sign in error: $error");
      return AuthModel(success: false, message: 'Google sign in failed: $error');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await UserUtils.clearUserData();
  }
} 