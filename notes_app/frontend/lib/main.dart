import 'package:flutter/material.dart';
import 'package:notes_app/screens/login_screen.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

void main() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  User().sharedPreferences = sharedPreferences;
  User().token = (sharedPreferences.get('token') ?? '') as String;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
          primarySwatch: Colors.orange,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              foregroundColor: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: User().token.isEmpty ? const LoginScreen() : const NotesScreen(),
    );
  }
}
