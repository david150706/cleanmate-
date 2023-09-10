import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:cleanmate/pages/main_page.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = Provider.of<AuthService>(context, listen: true).status;
    return Scaffold(
        body: authStatus == AuthStatus.Authenticated
            ? MainPage()
            : (authStatus == AuthStatus.Authenticating
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : LoginPage())
        // StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     // user is logged in
        //     if (snapshot.hasData) {
        //       return MainPage();
        //     } else {
        //       return LoginPage();
        //     }
        //   },
        // ),
        );
  }
}
