import 'package:flutter/material.dart';
import 'package:socialmediaapp/models/user_model.dart';
import 'package:socialmediaapp/screens/home.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/services/authService.dart';
import 'package:socialmediaapp/utils/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 230, 224, 224),
        centerTitle: true,
        title: const Text(
          "Sign Up Screen",
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
                  InputField(
                    inputController: _nameController,
                    size: 20,
                    text: "Enter Name",
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                  //   controller: _nameController,
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        UserModel? user = await AuthService().signUp(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 221, 136, 75)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        }
                      },
                      child: Text(
                        "Go To Log In",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 221, 136, 75)),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
