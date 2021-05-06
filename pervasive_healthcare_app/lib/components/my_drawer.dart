import 'package:flutter/material.dart';
import 'package:pervasive_healthcare_app/API/cardiologist_requests.dart';
import 'package:pervasive_healthcare_app/utils.dart' as utils;
import 'package:pervasive_healthcare_app/views/login_page.dart';

Widget getDrawer(BuildContext context) {
  return Drawer(
      child: Column(children: [
    Padding(
        padding: EdgeInsets.only(top: 50),
        child: Text("Pervasive Healthcare", style: TextStyle(fontSize: 20))),
    Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text("Il tuo ID: ${utils.id}")),
    ListTile(
      title: Text("Logout"),
      onTap: () async {
        await logout(utils.token);
        utils.id = null;
        utils.token = null;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return LoginPage();
        }));
      },
    )
  ]));
}
