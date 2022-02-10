import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/login_screen.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/widgets/textformfield.dart';

import '../models/user.dart';

class RegisterScreen extends StatelessWidget {
  final GlobalKey<FormState> password1 = GlobalKey<FormState>();
  final GlobalKey<FormState> password2 = GlobalKey<FormState>();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String password = '';
    User user = User();
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: min(MediaQuery.of(context).size.width - 60, 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create Account",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              AuthTextFormField(
                initialValue: user.email,
                onChanged: (str) => user.email = str ?? '',
                hinttext: "EMAIL",
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              PasswordTextFormField(
                passwordKey: password1,
                validator: (str) => (str ?? '').length < 6
                    ? '          Password must contain at least 6 characters.'
                    : null,
                onChanged: (str) => password = str ?? '',
              ),
              const SizedBox(height: 20),
              PasswordTextFormField(
                  passwordKey: password2,
                  validator: (str) => (str ?? '') == password
                      ? password.length < 6
                          ? '          Password must contain at least 6 characters.'
                          : null
                      : '         Passwords do not match.',
                  onChanged: null,
                  hintText: "CONFIRM PASSWORD"),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 193, 181, 214),
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 252, 227, 0),
                        Colors.orange
                      ])),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () async {
                      if (password1.currentState!.validate() &&
                          password2.currentState!.validate()) {
                        showLoader(context);
                        String? message = await User().signUp(password);
                        popLoader(context);
                        if (message == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Sign up Successful!')));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NotesScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Sign up failed. $message')));
                        }
                      }
                    },
                    icon: Text(
                      "SIGN UP",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    label: const Icon(
                      CupertinoIcons.arrow_right,
                      size: 15,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                    text: TextSpan(
                        text: "Already have an account?  ",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black54,
                            ),
                        children: [
                      TextSpan(
                          text: "Sign in",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen())),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange))
                    ])),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
