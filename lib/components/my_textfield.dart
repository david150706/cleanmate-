import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final String label;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            switch (label) {
              case 'username':
                return 'Por favor ingresa un usuario';
              case 'email':
                return 'Por favor ingresa un correo';
              case 'password':
                return 'Por favor ingresa una contraseña';
            }
            return 'Por favor ingresa algún texto';
          }
          return null;
        },
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey[950],
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Color(0xff6C6D72), fontSize: 16)),
      ),
    );
  }
}
