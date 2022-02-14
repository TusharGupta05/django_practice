import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_stream.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/screens/login_screen.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../widgets/note_card.dart';
import 'add_note.dart';
import 'change_password_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotesList notesList = NotesList();
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('All Notes'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                notesList.getNotesList();
              },
              icon: const Icon(Icons.refresh)),
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
      body: MultiProvider(
        providers: [
          Provider.value(value: notesList),
          StreamProvider<List<Note>>(
              create: (context) => notesList.stream, initialData: const []),
        ],
        builder: (_, __) {
          return Consumer<List<Note>>(
            builder: (___, List<Note> list, ____) {
              if (notesList.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (notesList.connectionState == ConnectionState.active) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (list.isEmpty) {
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
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    children: list
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (_) => AddNote(note: Note())));
          notesList.getNotesList();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
