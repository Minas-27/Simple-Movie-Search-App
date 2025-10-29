import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_authentication/screens/login_screen.dart';
import 'package:simple_authentication/screens/signup_screen.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Firebase Auth',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/signup': (_) => SignupScreen(),
        '/home': (_) => HomeScreen(),
      },
    );
  }
}
