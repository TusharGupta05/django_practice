import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/utils/functions.dart';

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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                note.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
