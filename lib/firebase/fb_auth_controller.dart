import 'package:firebase_auth/firebase_auth.dart';
import 'package:vp18_firebase/models/process_response.dart';

class FbAuthController {
  /// * Operations :
  ///    1) SignIn With Email & Password => (signIn()).
  ///    2) Create Account With Email & Password  => (register()).
  ///    3) Forget Password => (sendPasswordResetEmail()).
  ///    4) SignOut => (singOut()).
  ///    5) Current User => (user).
  ///    6) IsLoggedIn => (isLoggedIn).

  FbAuthController._();

  static FbAuthController? _instance;

  factory FbAuthController() {
    return _instance ??= FbAuthController._();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ProcessResponse> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      bool emailVerified = userCredential.user!.emailVerified;
      if (!emailVerified) await singOut();
      return ProcessResponse(
          emailVerified
              ? "Signed in Successfully"
              : "Email is not verified, verify and try again!",
          emailVerified);
    } on FirebaseException catch (e) {
      return ProcessResponse(e.message ?? '', false);
    }
  }

  Future<ProcessResponse> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      await _auth.signOut();
      return ProcessResponse("Registered successfully, verify email");
    } on FirebaseAuthException catch (e) {
      return ProcessResponse(e.message ?? '', false);
    }
  }

  Future<ProcessResponse> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ProcessResponse("Reset email sent successfully");
    } on FirebaseAuthException catch (e) {
      return ProcessResponse(e.message ?? '', false);
    }
  }

  Future<void> singOut() => _auth.signOut();

  User get user => _auth.currentUser!;

  bool get isLoggedIn => _auth.currentUser != null;
}
