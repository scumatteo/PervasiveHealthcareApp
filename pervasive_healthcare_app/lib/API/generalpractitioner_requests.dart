import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pervasive_healthcare_app/utils.dart' as utils;

Future<List<dynamic>> getMyInfo(String id, String token) async {
  var url = Uri.parse('${utils.apiPath}/generalpractitionerinfo/$id');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.get(url, headers: headers);
  return jsonDecode(response.body);
}

Future<List<dynamic>> getMyCardiology(String id, String token) async {
  var url = Uri.parse('${utils.apiPath}/cardiologypredictions/$id');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}
