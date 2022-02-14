import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:notes_app/utils/functions.dart';

import '../models/note.dart';

class AddNote extends StatelessWidget {
  final Note note;
  const AddNote({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.id == null ? "Add Note" : "Update Note"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const NotesScreen(),
              ),
            );
          },
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () async {
              if (note.title.isEmpty || note.description.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Title and description can not be empty.'),
                  ),
                );
                return;
              }
              showLoader(context);
              bool result = await note.postNote();
              popLoader(context);
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note saved successfully.'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to save the note. Please try again.'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              initialValue: note.title,
              onChanged: (str) => note.title = str,
              decoration: InputDecoration(
                hintText: 'Enter Title',
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: TextFormField(
                initialValue: note.description,
                onChanged: (str) => note.description = str,
                maxLines: null,
                expands: true,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
