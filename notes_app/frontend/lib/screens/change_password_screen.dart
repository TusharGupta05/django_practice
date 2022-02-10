import 'dart:math';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/functions.dart';
import '../widgets/textformfield.dart';
import 'notes_screen.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> password1 = GlobalKey<FormState>();
  final GlobalKey<FormState> password2 = GlobalKey<FormState>();
  final GlobalKey<FormState> password3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String oldPassword = '', newPassword = '';
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Change Password')),
      body: Center(
        child: SizedBox(
          width: min(MediaQuery.of(context).size.width - 60, 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              PasswordTextFormField(
                hintText: 'OLD PASSWORD',
                passwordKey: password1,
                validator: (str) => (str ?? '').length < 6
                    ? '          Password must contain at least 6 characters.'
                    : null,
                onChanged: (str) => oldPassword = str ?? '',
              ),
              const SizedBox(height: 20),
              PasswordTextFormField(
                hintText: 'NEW PASSWORD',
                passwordKey: password2,
                validator: (str) => (str ?? '').length < 6
                    ? '          Password must contain at least 6 characters.'
                    : null,
                onChanged: (str) => newPassword = str ?? '',
              ),
              const SizedBox(height: 20),
              PasswordTextFormField(
                  passwordKey: password3,
                  validator: (str) => (str ?? '') == newPassword
                      ? newPassword.length < 6
                          ? '          Password must contain at least 6 characters.'
                          : null
                      : '         Passwords do not match.',
                  onChanged: null,
                  hintText: "CONFIRM NEW PASSWORD"),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 40,
                  width: 155,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 193, 181, 214),
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 252, 227, 0),
                        Colors.orange
                      ])),
                  child: ElevatedButton(
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
                      if (password2.currentState!.validate() &&
                          password3.currentState!.validate()) {
                        showLoader(context);
                        String? message = await User()
                            .changePassword(oldPassword, newPassword);
                        popLoader(context);
                        if (message == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password reset successfully!'),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NotesScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password reset failed. $message'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "CHANGE PASSWORD",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
