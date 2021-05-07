import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> getMedicalRecords(String id, String token) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/medicalrecords/$id');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.get(url, headers: headers);

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

Future<Map<String, dynamic>> insertMedicalRecord(
    Map<String, dynamic> body, String token) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/medicalrecords');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var bodyJson = jsonEncode(body);
  var response = await http.post(url, body: bodyJson, headers: headers);
  return jsonDecode(response.body);
}

Future<List<dynamic>> getKinshipDegree() async {
  var url = Uri.parse('http://10.0.2.2:8080/api/kinshipdegrees');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}
