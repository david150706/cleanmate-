import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cleanmate/components/my_button.dart';
import 'package:cleanmate/components/my_textfield.dart';
import 'package:cleanmate/components/square_tile.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSigningIn = true;

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final authService = Provider.of<AuthService>(context, listen: false);
    // try sign in
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final authService = Provider.of<AuthService>(context, listen: false);
    // try sign up
    try {
      final authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User user = authResult.user!;
      await authService.updateUserData(user, true,
          displayName: usernameController.text);
      // pop the loading circle
      Navigator.pop(context);
    } catch (e) {}
    //TODO: Notificar si el correo ya esta en uso
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Correo Incorrecto',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Contraseña Incorrecta',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Text(
                    'CleanMate',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 30),

                  // welcome back, you've been missed!
                  Text(
                    _isSigningIn
                        ? 'Bienvenido de nuevo!'
                        : 'Crear nueva cuenta',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Visibility(
                    visible: !_isSigningIn,
                    child: MyTextField(
                      controller: usernameController,
                      hintText: 'Usuario',
                      obscureText: false,
                      label: 'username',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Correo',
                    obscureText: false,
                    label: 'email',
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    label: 'password',
                  ),

                  const SizedBox(height: 10),

                  // forgot password?

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (_isSigningIn) {
                          signUserIn();
                        } else {
                          signUserUp();
                        }
                      }
                    },
                    isSigningIn: _isSigningIn,
                  ),

                  const SizedBox(height: 30),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'O continua con',
                            //style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      GestureDetector(
                        child: const SquareTile(
                            imagePath: 'lib/images/google.png'),
                        onTap: () async {
                          await authService.googleSignIn();
                        },
                      ),
                      // apple button
                    ],
                  ),

                  const SizedBox(height: 35),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSigningIn
                            ? 'No tienes cuenta?'
                            : 'Ya tienes cuenta?',
                        //style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        style: ButtonStyle(),
                        child: Text(
                          _isSigningIn ? 'Registrate ahora' : 'Inicia sesión',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (_isSigningIn) {
                            setState(() {
                              _isSigningIn = false;
                            });
                          } else {
                            setState(() {
                              _isSigningIn = true;
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
