import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/models/user_model.dart';
import 'package:socialmediaapp/screens/home.dart';
import 'package:socialmediaapp/screens/register.dart';
import 'package:socialmediaapp/services/authService.dart';
import 'package:socialmediaapp/utils/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 230, 224, 224),
        centerTitle: true,
        title: const Text(
          "Login Screen",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // TextField(
                  //   controller: _emailController,
                  // ),
                  InputField(
                    inputController: _emailController,
                    size: 20,
                    text: "Enter Email",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    inputController: _passwordController,
                    size: 20,
                    text: "Enter Password",
                  ),
                  // TextField(
                  //   controller: _passwordController,
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        UserModel? user = await AuthService().LogIn(
                            _emailController.text, _passwordController.text);
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        }
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 221, 136, 75)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await AuthService().signInwithGoogle();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } on FirebaseAuthException catch (e) {
                          print("google sign in dint workk");
                          print(e.toString);
                        }
                      },
                      child: Text(
                        "Sign In With Google",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 221, 136, 75)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      },
                      child: const Text(
                        "Go to Sign Up",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 221, 136, 75)),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
