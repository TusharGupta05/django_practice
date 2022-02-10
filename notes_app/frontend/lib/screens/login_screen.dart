import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/register.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/widgets/textformfield.dart';

import '../models/user.dart';
import 'forgot_password.dart';
import 'notes_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String password = '';
    GlobalKey<FormState> passwordKey =
        GlobalKey<FormState>(debugLabel: 'LoginPassword');
    User user = User();
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: min(MediaQuery.of(context).size.width - 60, 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline3!.merge(
                  const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Text(
              "Please sign in to continue",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 40),
            AuthTextFormField(
              initialValue: user.email,
              onChanged: (str) => user.email = str ?? '',
              hinttext: "EMAIL",
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),
            PasswordTextFormField(
              passwordKey: passwordKey,
              validator: (str) =>
                  (str ?? '').isEmpty ? '       Invalid password' : null,
              onChanged: (str) => password = str ?? '',
            ),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.center,
                child: TextButton(
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                )),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () async {
                    if (passwordKey.currentState!.validate()) {
                      showLoader(context);
                      bool result = await user.signIn(password);
                      popLoader(context);
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Successful!')));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotesScreen()),
                            (_) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid credentials.')));
                      }
                    }
                  },
                  icon: Text(
                    "LOGIN",
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
                  text: "Don't have an account?  ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black54,
                      ),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RegisterScreen())),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      )),
    );
  }
}
