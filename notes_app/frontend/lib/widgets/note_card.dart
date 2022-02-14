import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_stream.dart';
import 'package:notes_app/utils/functions.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({Key? key, required this.note}) : super(key: key);
  final Note note;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 140,
        // maxHeight: MediaQuery.of(context).size.height / 3,
        maxWidth: max(150, (MediaQuery.of(context).size.width / 5) * 2),
        minHeight: 140,
        minWidth: min(100, MediaQuery.of(context).size.width / 2),
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      note.title,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton<Note>(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<Note>(
                              value: note, child: const Text('Delete'))
                        ];
                      },
                      onSelected: (_) async {
                        showLoader(context);
                        final bool res = await note.deleteNote();
                        popLoader(context);
                        String msg = res
                            ? 'Note deleted successfully!'
                            : 'Failed to delete the note. Please try again.';
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));
                        if (res) {
                          Provider.of<NotesList>(context, listen: false)
                              .getNotesList();
                        }
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                note.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                dateToString(note.lastEdited!),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black45),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
