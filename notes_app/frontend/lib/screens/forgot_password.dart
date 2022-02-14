import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/utils/api_utils.dart';
import 'package:http/http.dart';
import '../constants/api_constants.dart';
import '../enums/method_type.dart';
import '../models/user.dart';
import '../widgets/textformfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                "Forgot Password?",
                style: Theme.of(context).textTheme.headline3!.merge(
                    const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter your registered email address below and we will send an email with instructions to reset your password.",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
              ),
              const SizedBox(height: 40),
              AuthTextFormField(
                initialValue: user.email,
                onChanged: (str) => user.email = str ?? '',
                hinttext: "EMAIL",
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 40,
                  width: 120,
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
                      Response response = await makeApiCall(
                          ApiConstants.forgotPasswordUrl, MethodType.post,
                          body: {'email': user.email});
                      if (ApiConstants.successCodes
                          .contains(response.statusCode)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Password reset email sent successfully. Please check your inbox.'),
                          ),
                        );
                      } else {
                        String msg = response.statusCode == 404
                            ? 'User does not exist.'
                            : jsonDecode(response.body)['msg'];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "SEND EMAIL",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        for (var state in [
                          MaterialState.hovered,
                          MaterialState.pressed,
                          MaterialState.focused,
                          MaterialState.selected,
                        ]) {
                          if (states.contains(state)) {
                            return Colors.black.withOpacity(0.05);
                          }
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Transform.rotate(
                      angle: pi,
                      child: const Icon(
                        Icons.arrow_right_alt,
                        color: Colors.orange,
                      )),
                  label: const Text(
                    'Back to login',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
