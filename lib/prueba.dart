import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      Card(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
        ),
        color: Colors.deepPurple,
        )
        ]
        ),
        );
  }
}