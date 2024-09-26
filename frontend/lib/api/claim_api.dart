import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petfight/constants.dart';

Future<bool> postClaimed({required String token}) async {
  var url = Uri.parse(Endpoints.claim);
  var headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({'token': token});
  
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