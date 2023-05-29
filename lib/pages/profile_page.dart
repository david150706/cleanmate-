import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Stream getUser(authService) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authService.user.id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: StreamBuilder(
          stream: getUser(authService),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 70),
                      CircleAvatar(
                        radius: 70,
                        foregroundImage: snapshot.data['photoURL'] == null
                            ? null
                            : Image.network(snapshot.data['photoURL']).image,
                        child: snapshot.data['photoURL'] == null
                            ? const Icon(
                                Icons.account_circle,
                                size: 120,
                              )
                            : null,
                      ),
                      SizedBox(height: 25),
                      Text(
                        snapshot.data['displayName'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: authService.signOut,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffAF87FF), width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.deepPurple,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Cerrar Sesión',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
