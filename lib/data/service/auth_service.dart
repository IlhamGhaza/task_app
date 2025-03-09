import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'database_service.dart';

class AuthService {
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<void> storeUserCredentials(String email, String uid) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'uid', value: uid);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    return {
      'email': await _storage.read(key: 'email'),
      'uid': await _storage.read(key: 'uid'),
    };
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading = true;
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      User? user = result.user;
      if (user != null) {
        await storeUserCredentials(email, user.uid);
        log('User logged in with email: ${user.email}');
        log('User logged in with uid: ${user.uid}');
      }
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      isLoading = true;
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      User? user = result.user;
      if (user != null) {
        await DatabaseService(uid: user.uid).createUserProfile(
          name: email.split('@')[0], // Using email prefix as initial name
          email: email,
        );

        await storeUserCredentials(email, user.uid);
        log('User registered with email: ${user.email}');
        log('User registered with uid: ${user.uid}');
      }
      log(user.toString());
      return result.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      print('User signed out');
      return await _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // reset password
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
