import 'package:flutter/material.dart';

import 'package:gurukulam/views/login/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const GurukulamApp(),
  );
}

class GurukulamApp
    extends StatelessWidget {
  const GurukulamApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title: 'Gurukulam',

      theme: ThemeData(
        fontFamily: 'Poppins',

        colorScheme:
            ColorScheme.fromSeed(
          seedColor:
              const Color(
            0xFF2563EB,
          ),
        ),

        useMaterial3: true,
      ),

      home:
          const LoginView(),
    );
  }
}