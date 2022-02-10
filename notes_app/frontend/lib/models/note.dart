import 'package:http/http.dart';
import 'package:notes_app/constants/api_constants.dart';
import 'package:notes_app/enums/method_type.dart';
import 'package:notes_app/utils/api_utils.dart';

class Note {
  int? id;
  String title, description;
  DateTime? lastEdited;
  Note({this.id, this.title = '', this.description = '', this.lastEdited});
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      lastEdited: DateTime.parse(json['last_edited']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  Future<bool> postNote() async {
    late Response response;
    if (id == null) {
      response =
          await makeApiCall(ApiConstants.notesList, MethodType.post, toMap());
    } else {
      response = await makeApiCall(
          '${ApiConstants.notesList}$id', MethodType.put, toMap());
    }
    if ([200, 201, 202].contains(response.statusCode)) {
      return true;
    }
    return false;
  }
}
