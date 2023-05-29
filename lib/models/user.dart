import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String id;
  String displayName;
  String? photoURL;
  String email;

  User({
    this.id = '',
    this.displayName = '',
    this.photoURL = '',
    this.email = '',
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> userDoc) {
    Map<String, dynamic> userData = userDoc.data()!;
    return User(
      id: userDoc.reference.id,
      displayName: userData['displayName'],
      photoURL: userData['photoURL'],
      email: userData['email'],
    );
  }

  void setFromFireStore(DocumentSnapshot<Map<String, dynamic>> userDoc) {
    Map userData = userDoc.data()!;
    this.id = userDoc.reference.id;
    this.displayName = userData['displayName'];
    this.photoURL = userData['photoURL'];
    this.email = userData['email'];
    notifyListeners();
  }
}
