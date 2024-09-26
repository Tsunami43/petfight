import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petfight/constants.dart';

Future<bool> postTask({required String token, required String taskKey}) async {
  var url = Uri.parse(Endpoints.task);
  var headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({'token': token, 'task_key': taskKey});
  
  try {
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}