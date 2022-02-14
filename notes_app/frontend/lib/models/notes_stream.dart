import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/utils/api_utils.dart';

import '../constants/api_constants.dart';
import '../enums/method_type.dart';

class NotesList {
  ConnectionState connectionState = ConnectionState.none;
  NotesList() {
    _streamController = StreamController();
    getNotesList();
  }
  late StreamController<List<Note>> _streamController;
  Stream<List<Note>> get stream => _streamController.stream;
  void getNotesList() {
    connectionState = ConnectionState.waiting;
    makeApiCall(ApiConstants.notesList, MethodType.get).then(
      (value) {
        connectionState = ConnectionState.active;
        final Response response = value;
        if (ApiConstants.successCodes.contains(response.statusCode)) {
          List<dynamic> json = jsonDecode(response.body);
          final List<Note> notesList = List<Note>.generate(
              json.length, (index) => Note.fromJson(json[index]));
          _streamController.add(notesList);
        }
        connectionState = ConnectionState.done;
      },
    );
  }
}
