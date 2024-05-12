import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/firebase_options.dart';
import 'package:socialmediaapp/screens/home.dart';
import 'package:socialmediaapp/screens/register.dart';
import 'package:socialmediaapp/services/authService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

//to ensure user stays signed In until logged out
class _MyAppState extends State<MyApp> {
  User? user;
  AuthService service = new AuthService();
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    user = service.getUser();
    print(user?.email);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 230, 224, 224),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 150, 145, 158)),
        useMaterial3: true,
      ),
      home: user != null ? HomeScreen() : SignUpScreen(),
    );
  }
}
