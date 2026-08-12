import 'package:flutter/material.dart';
import 'package:gurukulam/viewModels/login_viewmodel.dart';
import 'package:gurukulam/viewModels/master_viewmodel.dart';
import 'package:gurukulam/views/login/login_view.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(
          create: (_) => MasterViewModel(tableName: '', title: ''),
        ),
      ],
      child: const GurukulamApp(),
    ),
  );
}

class GurukulamApp extends StatelessWidget {
  const GurukulamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 600),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'Gurukulam',

        theme: ThemeData(
          fontFamily: 'Cambria',

          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),

          useMaterial3: true,
        ),

        home: const LoginView(),
      ),
    );
  }
}
