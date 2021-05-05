import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pervasive_healthcare_app/utils.dart' as utils;

Future<List<dynamic>> getCardiologyVisits(String id, String token) async {
  var url = Uri.parse('${utils.apiPath}/cardiologyvisits/$id');
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
  var url = Uri.parse('${utils.apiPath}/cardiologyvisits');
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
  var url = Uri.parse('${utils.apiPath}/logout');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'x-access-token': token
  };
  var response = await http.post(url, headers: headers);
}

Future<List<dynamic>> getChestPainType() async {
  var url = Uri.parse('${utils.apiPath}/chestpaintypes');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);
  return jsonDecode(response.body);
}

Future<List<dynamic>> getRestingECG() async {
  var url = Uri.parse('${utils.apiPath}/restingecg');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}

Future<List<dynamic>> getslopeST() async {
  var url = Uri.parse('${utils.apiPath}/slopest');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}

Future<List<dynamic>> getThal() async {
  var url = Uri.parse('${utils.apiPath}/thals');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(url, headers: headers);

  return jsonDecode(response.body);
}
