// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/components/items.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 120),
                // logo
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 35),
                // welcome back message
                const Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 25),
                // email
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // password
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 50),
                // signin button
                MyButton(onTap: signIn, text: "Sign in"),
                // register now
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Not a member yet?"),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: widget.onTap,
                      // onTap: () {
                      //   tooglePages();
                      //   // Navigator.pushReplacement(
                      //   //   context,
                      //   //   MaterialPageRoute(
                      //   //     builder: (BuildContext context) =>
                      //   //         const RegisterPage(),
                      //   //   ),
                      //   // );
                      // },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
