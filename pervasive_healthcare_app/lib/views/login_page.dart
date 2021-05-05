import 'package:flutter/material.dart';
import 'package:pervasive_healthcare_app/API/auth.dart';
import 'package:pervasive_healthcare_app/views/cardiologist_page.dart';
import 'package:menu_button/menu_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscureText = true;

  List<String> keys = <String>[
    'Low',
    'Medium',
    'High',
  ];
  String selectedKey;

  @override
  void initState() {
    selectedKey = keys[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: idController,
                      decoration: InputDecoration(labelText: "ID"),
                      validator: (id) {
                        if (id == null || id.isEmpty) {
                          return "Campo obbligatorio";
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return "Campo obbligatorio";
                        }
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                          labelText: "Password",
                          suffixIcon: IconButton(
                              icon: Icon(this.obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              iconSize: 18,
                              onPressed: () {
                                setState(() {
                                  this.obscureText = !this.obscureText;
                                });
                              })),
                    ),
                    MenuButton<String>(
                      child: Container(width: 100, child: Text(selectedKey)),
                      items: keys,
                      itemBuilder: (String value) => Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16),
                        child: Text(value),
                      ),
                      onItemSelected: (String value) {
                        setState(() {
                          selectedKey = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              TextButton(onPressed: () => submit(), child: Text("Login"))
            ],
          )),
    );
  }

  Future<void> submit() async {
    if (formKey.currentState.validate()) {
      String id = idController.text;
      Map<String, dynamic> response = await login(id, passwordController.text);
      if (response["@type"] == "Rejected") {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Credenziali errate"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ],
              );
            });
      } else {
        int role = response["role"]["id"];
        String token = response["token"];
        switch (role) {
          case 0:
            print("patient");
            break;
          case 1:
            print("general practitioner");
            break;
          case 2:
            print("surgeon");
            break;
          case 8:
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return CardiologistPage(id, token);
            }));

            break;
          default:
            print("Error");
        }
      }
    }
  }
}
