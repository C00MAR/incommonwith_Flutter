import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthViewModel({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    setLoading(true);
    clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          setError('Aucun utilisateur trouvé avec cet email');
          break;
        case 'wrong-password':
          setError('Mot de passe incorrect');
          break;
        case 'invalid-email':
          setError('Email invalide');
          break;
        default:
          setError('Erreur de connexion : ${e.message}');
      }
    } catch (e) {
      setError('Erreur inattendue : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    setLoading(true);
    clearError();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          setError('Cet email est déjà utilisé');
          break;
        case 'weak-password':
          setError('Le mot de passe est trop faible');
          break;
        case 'invalid-email':
          setError('Email invalide');
          break;
        default:
          setError('Erreur d\'inscription : ${e.message}');
      }
    } catch (e) {
      setError('Erreur inattendue : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    clearError();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setLoading(false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setError('Erreur de connexion Google : ${e.message}');
    } catch (e) {
      setError('Erreur inattendue : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      setError('Erreur lors de la déconnexion : $e');
    }
  }
}
