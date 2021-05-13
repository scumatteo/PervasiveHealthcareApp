import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pervasive_healthcare_app/utils.dart' as utils;

Future<List<dynamic>> getMedicalRecords(String id, String token) async {
  var url = Uri.parse('${utils.apiPath}/medicalrecords/$id');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}

Future<void> logout(String token) async {
  var url = Uri.parse('${utils.apiPath}/logout');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.post(url, headers: headers);
}

Future<Map<String, dynamic>> insertMedicalRecord(
    Map<String, dynamic> body, String token) async {
  var url = Uri.parse('${utils.apiPath}/medicalrecords');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var bodyJson = jsonEncode(body);
  var response = await http.post(url, body: bodyJson, headers: headers);
  print(jsonDecode(response.body));
  return jsonDecode(response.body);
}

Future<List<dynamic>> getKinshipDegree() async {
  var url = Uri.parse('${utils.apiPath}/kinshipdegrees');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}
