import 'package:cleanmate/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/main_page.dart';
import 'models/app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthService.instance(),
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            // Rutas
          },
          debugShowCheckedModeBanner: false,
          home: AuthPage(),
          theme: AppTheme.themeData(context),
        ));
  }
}
