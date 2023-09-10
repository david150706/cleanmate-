import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as appUser;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth;
  late GoogleSignInAccount _googleUser;
  appUser.User _user = appUser.User();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthStatus _status = AuthStatus.Uninitialized;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.Unauthenticated;
    } else {
      DocumentSnapshot<Map<String, dynamic>> userSnap =
          await _db.collection('users').doc(firebaseUser.uid).get();

      _user.setFromFireStore(userSnap);
      _status = AuthStatus.Authenticated;
    }

    notifyListeners();
  }

  Future<User?> googleSignIn() async {
    _status = AuthStatus.Authenticating;
    notifyListeners();
    print('--------------');
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      print('--------------');
      this._googleUser = googleUser;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      User user = authResult.user!;
      await updateUserData(user, false);
    } catch (e) {
      print('erroooooooooooooooooooooor');
      print(e);
      _status = AuthStatus.Uninitialized;
      notifyListeners();
      return null;
    }
  }

  Future updateUserData(User user, bool isSigningUp,
      {String? displayName}) async {
    DocumentReference userRef = _db.collection('users').doc(user.uid);
    print(userRef);
    if (isSigningUp) {
      await userRef.set(
        {
          'uid': user.uid,
          'email': user.email,
          'photoURL': user.photoURL,
          'displayName': isSigningUp ? displayName : user.displayName,
          'devices': [],
        },
      );
    }
  }

  void signOut() {
    _auth.signOut();
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
  }

  void updateAuthStatus(AuthStatus st) {
    _status = st;
    notifyListeners();
  }

  AuthStatus get status => _status;
  appUser.User get user => _user;
  GoogleSignInAccount get googleUser => _googleUser;
}
