import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _appUser;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authService.currentUser != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        _appUser = await _authService.getUserData(user.uid);
      } else {
        _appUser = null;
      }
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.login(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Erreur de connexion";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String prenom,
    required String nom,
    required String email,
    required String telephone,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _appUser = await _authService.register(
        prenom: prenom,
        nom: nom,
        email: email,
        telephone: telephone,
        password: password,
        role: role,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Erreur d'inscription";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final cred = await _authService.signInWithGoogle();
      return cred != null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _appUser = null;
    notifyListeners();
  }
}