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

Future<Map<String, dynamic>> insertCardiologyVisit(
    Map<String, dynamic> body, String token) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/cardiologyvisits');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var bodyJson = jsonEncode(body);
  var response = await http.post(url, body: bodyJson, headers: headers);
  return jsonDecode(response.body);
}

Future<void> logout(String token) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/logout');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.post(url, headers: headers);
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

Future<List<dynamic>> getRestingECG() async {
  var url = Uri.parse('http://10.0.2.2:8080/api/restingecg');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}

Future<List<dynamic>> getslopeST() async {
  var url = Uri.parse('http://10.0.2.2:8080/api/slopest');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}

Future<List<dynamic>> getThal() async {
  var url = Uri.parse('http://10.0.2.2:8080/api/thals');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}
