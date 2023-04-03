// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:heyfluttersigninemailverification/widgets/utils.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  RegExp pass_valid =
      RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
  double pass_strength = 0;
  final formKey = GlobalKey<FormState>();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LottieBuilder.asset('assets/signup.json'),
            Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator: (value) => value != null && value.length < 6
                    //     ? 'Enter min. 6 character'
                    //     : null,
                    validator: (value) => value != null &&
                            !pass_valid.hasMatch(value)
                        ? 'Password should contain capital letter, small letter, number and special symbol'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/Capture.PNG'),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: signUp,
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 32,
                    ),
                    label: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                        text: 'Already have an account',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: 'Login',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  void signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    //Navigator.of(context) not working

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
