import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:notes_app/constants/api_constants.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/screens/login_screen.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:notes_app/widgets/note_card.dart';

import '../models/note.dart';
import 'add_note.dart';
import 'change_password_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('All Notes'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ChangePasswordScreen()));
              } else if (value == 1) {
                showLoader(context);
                bool success = await User().logout();
                popLoader(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Log out successful!'),
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to log out. Please try again.'),
                    ),
                  );
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem<int>(
                  value: 0, child: Text('Change Password')),
              const PopupMenuItem<int>(value: 1, child: Text('Log out')),
            ],
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<Response>(
        future: get(Uri.parse(ApiConstants.notesList),
            headers: {'Authorization': "Token ${User().token}"}),
        builder: (_, AsyncSnapshot<Response> snapshot) {
          Response? response = snapshot.data;
          if (response == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // print(response.body);
          List<dynamic> json = jsonDecode(response.body);
          if (json.isEmpty) {
            return Center(
              child: Text(
                'No note added yet!',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            );
          }
          List<Note> notesList =
              List.generate(json.length, (index) => Note.fromJson(json[index]));
          for (int i = 0; i < min(10, max(10, notesList.length)); i++) {
            notesList.add(notesList[i]);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Wrap(
                children: notesList
                    .map(
                      (note) => GestureDetector(
                        child: NoteCard(note: note),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddNote(note: note),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AddNote(note: Note())));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
