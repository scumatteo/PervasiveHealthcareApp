import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> getCardiologyVisits(String id, String token) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/cardiologyvisits/$id');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}

Future<List<dynamic>> getChestPainType() async {
  var url = Uri.parse('http://10.0.2.2:8080/api/chestpaintypes');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}
