import 'package:http/http.dart';
import 'package:notes_app/enums/method_type.dart';
import 'package:notes_app/models/user.dart';

Future<Response> makeApiCall(String url, MethodType methodType,
    {Map<String, dynamic>? body}) async {
  late Response response;
  Map<String, String> headers = {'Authorization': 'Token ${User().token}'};
  if (methodType == MethodType.get) {
    response = await get(Uri.parse(url), headers: headers);
  } else if (methodType == MethodType.post) {
    response = await post(Uri.parse(url), body: body, headers: headers);
  } else if (methodType == MethodType.delete) {
    response = await delete(Uri.parse(url), headers: headers, body: body);
  } else if (methodType == MethodType.put) {
    response = await put(Uri.parse(url), headers: headers, body: body);
  }
  return response;
}
