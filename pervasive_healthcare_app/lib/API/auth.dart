import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login(String id, String password) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/login');
  var body = jsonEncode({'id': id, 'password': password});
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.post(url, body: body, headers: headers);
  return jsonDecode(response.body);
}
