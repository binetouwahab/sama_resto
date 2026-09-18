import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AppUser?> register({
    required String prenom,
    required String nom,
    required String email,
    required String telephone,
    required String password,
    required String role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final appUser = AppUser(
      id: cred.user!.uid,
      prenom: prenom,
      nom: nom,
      email: email,
      telephone: telephone,
      role: role,
    );
    await _db.collection('users').doc(appUser.id).set(appUser.toMap());
    return appUser;
  }

  Future<UserCredential> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);

    final docRef = _db.collection('users').doc(userCred.user!.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set(AppUser(
        id: userCred.user!.uid,
        prenom: userCred.user!.displayName ?? '',
        nom: '',
        email: userCred.user!.email ?? '',
        telephone: '',
        role: 'client',
      ).toMap());
    }
    return userCred;
  }

  Future<AppUser?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!, doc.id);
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}