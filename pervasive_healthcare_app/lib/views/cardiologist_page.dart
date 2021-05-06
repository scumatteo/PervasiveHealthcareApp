import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menu_button/menu_button.dart';
import 'package:pervasive_healthcare_app/API/cardiologist_requests.dart';
import 'package:pervasive_healthcare_app/components/my_drawer.dart';
import 'package:pervasive_healthcare_app/utils.dart' as utils;
import 'package:pervasive_healthcare_app/views/login_page.dart';

class CardiologistPage extends StatefulWidget {
  CardiologistPage();

  @override
  _CardiologistPageState createState() => _CardiologistPageState();
}

class _CardiologistPageState extends State<CardiologistPage> {
  var chestPainTypeFuture = getChestPainType();
  var restingECGFuture = getRestingECG();
  var slopeSTFuture = getslopeST();
  var thalFuture = getThal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Le mie visite")),
      drawer: getDrawer(context),
      body: FutureBuilder<List<dynamic>>(
          future: getCardiologyVisits(utils.id, utils.token),
          builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("ID paziente:"),
                                      Text("ID visita:"),
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${snapshot.data[i]["patientID"]["value"]}"),
                                  Text(
                                      "${snapshot.data[i]["cardiologyVisitID"]["value"]}"),
                                ],
                              )
                            ]),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return CardiologistDetailPage(snapshot.data[i]);
                          }));
                        },
                      );
                    });
                break;
              default:
                return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            var chestPainType = await chestPainTypeFuture;
            var restingECG = await restingECGFuture;
            var slopeST = await slopeSTFuture;
            var thal = await thalFuture;
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return CardiologistInsertPage(
                  chestPainType, restingECG, slopeST, thal);
            }));
          }),
    );
  }
}

class CardiologistInsertPage extends StatefulWidget {
  List<dynamic> chestPainType;
  List<dynamic> restingECG;
  List<dynamic> slopeST;
  List<dynamic> thal;

  CardiologistInsertPage(
      this.chestPainType, this.restingECG, this.slopeST, this.thal);

  @override
  _CardiologistInsertPageState createState() => _CardiologistInsertPageState();
}

class _CardiologistInsertPageState extends State<CardiologistInsertPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController visitIDController = TextEditingController();
  TextEditingController doctorIDController = TextEditingController();
  TextEditingController patientIDController = TextEditingController();
  TextEditingController restingBloodPressureController =
      TextEditingController();
  TextEditingController cholesterolController = TextEditingController();
  TextEditingController maxHeartRateController = TextEditingController();
  TextEditingController oldPeakSTController = TextEditingController();
  TextEditingController numberVesselController = TextEditingController();

  Map<int, String> chestPainTypeMap = {};
  Map<int, String> restingECGMap = {};
  Map<int, String> slopeSTMap = {};
  Map<int, String> thalMap = {};

  int chestPainSelectedIndex = 0;
  int restingECGSelectedIndex = 0;
  int slopeSTSelectedIndex = 0;
  int thalSelectedIndex = 0;

  int fastingBloodSugarSelected = 0;
  List<int> fastingBloodSugarChoice = [0, 1];
  int isAnginaSelected = 0;
  List<int> isAnginaChoice = [0, 1];

  @override
  void initState() {
    doctorIDController.text = utils.id;
    widget.chestPainType.forEach((element) {
      chestPainTypeMap[element["id"]] = element["value"];
    });
    widget.restingECG.forEach((element) {
      restingECGMap[element["id"]] = element["value"];
    });
    widget.slopeST.forEach((element) {
      slopeSTMap[element["id"]] = element["value"];
    });
    widget.thal.forEach((element) {
      thalMap[element["id"]] = element["value"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inserisci referto"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () => insert())
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: visitIDController,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration: InputDecoration(labelText: "ID visita"),
                  ),
                  TextFormField(
                    controller: doctorIDController,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    enabled: false,
                    decoration: InputDecoration(labelText: "ID dottore"),
                  ),
                  TextFormField(
                    controller: patientIDController,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration: InputDecoration(labelText: "ID paziente"),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(children: [
                        Text("Tipo di dolore toracico: "),
                        MenuButton<int>(
                          child: Container(
                              width: 150,
                              height: 30,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 6, left: 10),
                                  child: Text(chestPainTypeMap[
                                      chestPainSelectedIndex]))),
                          items: chestPainTypeMap.keys.toList(),
                          itemBuilder: (int value) => Container(
                            width: 150,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16),
                            child: Text(chestPainTypeMap[value]),
                          ),
                          onItemSelected: (int value) {
                            setState(() {
                              chestPainSelectedIndex = value;
                            });
                          },
                        )
                      ])),
                  TextFormField(
                    controller: restingBloodPressureController,
                    keyboardType: TextInputType.number,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "Pressione sanguigna"),
                  ),
                  TextFormField(
                    controller: cholesterolController,
                    keyboardType: TextInputType.number,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration: InputDecoration(labelText: "Colesterolo"),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Text("Concentrazione zuccheri > 120mg/dl"),
                          RadioListTile<int>(
                              value: 0,
                              groupValue: fastingBloodSugarChoice[
                                  fastingBloodSugarSelected],
                              title: Text("No"),
                              onChanged: (value) {
                                setState(() {
                                  this.fastingBloodSugarSelected = value;
                                });
                              }),
                          RadioListTile<int>(
                              value: 1,
                              groupValue: fastingBloodSugarChoice[
                                  fastingBloodSugarSelected],
                              title: Text("Sì"),
                              onChanged: (value) {
                                setState(() {
                                  this.fastingBloodSugarSelected = value;
                                });
                              }),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(children: [
                        Text("Valore elettrocardiogramma: "),
                        MenuButton<int>(
                          child: Container(
                              width: 150,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(
                                      restingECGMap[restingECGSelectedIndex]))),
                          items: restingECGMap.keys.toList(),
                          itemBuilder: (int value) => Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16),
                            child: Text(restingECGMap[value]),
                          ),
                          onItemSelected: (int value) {
                            setState(() {
                              restingECGSelectedIndex = value;
                            });
                          },
                        )
                      ])),
                  TextFormField(
                    controller: maxHeartRateController,
                    keyboardType: TextInputType.number,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "Battiti cardiaci (max): "),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Text("Angina indotta"),
                          RadioListTile<int>(
                              value: 0,
                              groupValue: isAnginaChoice[isAnginaSelected],
                              title: Text("No"),
                              onChanged: (value) {
                                setState(() {
                                  this.isAnginaSelected = value;
                                });
                              }),
                          RadioListTile<int>(
                              value: 1,
                              groupValue: isAnginaChoice[isAnginaSelected],
                              title: Text("Sì"),
                              onChanged: (value) {
                                setState(() {
                                  this.isAnginaSelected = value;
                                });
                              }),
                        ],
                      )),
                  TextFormField(
                    controller: oldPeakSTController,
                    keyboardType: TextInputType.number,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "Vecchio picco ST: "),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(children: [
                        Text("Andamento ST: "),
                        MenuButton<int>(
                          child: Container(
                              width: 150,
                              height: 50,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child:
                                      Text(slopeSTMap[slopeSTSelectedIndex]))),
                          items: restingECGMap.keys.toList(),
                          itemBuilder: (int value) => Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16),
                            child: Text(slopeSTMap[value]),
                          ),
                          onItemSelected: (int value) {
                            setState(() {
                              slopeSTSelectedIndex = value;
                            });
                          },
                        )
                      ])),
                  TextFormField(
                    controller: numberVesselController,
                    keyboardType: TextInputType.number,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "Numero vasi colorati"),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 90),
                      child: Row(children: [
                        Text("Tipo difetto: "),
                        MenuButton<int>(
                          child: Container(
                              width: 150,
                              height: 40,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10),
                                  child: Text(thalMap[thalSelectedIndex]))),
                          items: restingECGMap.keys.toList(),
                          itemBuilder: (int value) => Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16),
                            child: Text(thalMap[value]),
                          ),
                          onItemSelected: (int value) {
                            setState(() {
                              thalSelectedIndex = value;
                            });
                          },
                        )
                      ])),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> insert() async {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> body = {};
      body["cardiologyVisitID"] = {"value": visitIDController.text};
      body["doctorID"] = {"value": doctorIDController.text};
      body["patientID"] = {"value": patientIDController.text};
      body["chestPainType"] = {
        "id": chestPainSelectedIndex,
        "value": chestPainTypeMap[chestPainSelectedIndex]
      };
      body["restingBloodPressure"] = {
        "value": int.parse(restingBloodPressureController.text)
      };
      body["cholesterol"] = {"value": int.parse(cholesterolController.text)};
      body["patientID"] = {"value": patientIDController.text};
      body["fastingBloodSugar"] = {
        "value": fastingBloodSugarSelected == 1 ? true : false
      };
      body["restingElectrocardiographic"] = {
        "id": restingECGSelectedIndex,
        "value": restingECGMap[restingECGSelectedIndex]
      };
      body["maxHeartRate"] = {"value": int.parse(maxHeartRateController.text)};
      body["isAnginaInducted"] = isAnginaSelected == 1 ? true : false;
      body["oldPeakST"] = {"value": double.parse(oldPeakSTController.text)};
      body["slopeST"] = {
        "id": slopeSTSelectedIndex,
        "value": slopeSTMap[slopeSTSelectedIndex]
      };
      body["numberVesselColoured"] = {
        "value": int.parse(numberVesselController.text)
      };
      body["thal"] = {
        "id": thalSelectedIndex,
        "value": thalMap[thalSelectedIndex]
      };
      body["visitDate"] = {"visitDate": utils.localDate.format(DateTime.now())};
      Map<String, dynamic> response =
          await insertCardiologyVisit(body, utils.token);
      bool accepted = response["@type"] == "Accepted";
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title:
                  Text(accepted ? response["description"] : response["reason"]),
            );
          });
      if (accepted) {
        Future.delayed(Duration(seconds: 1)).then((value) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return CardiologistPage();
          }));
        });
      }
    }
  }
}

class CardiologistDetailPage extends StatefulWidget {
  Map<String, dynamic> visit;

  CardiologistDetailPage(this.visit);
  @override
  _CardiologistDetailPageState createState() => _CardiologistDetailPageState();
}

class _CardiologistDetailPageState extends State<CardiologistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Visita cardiologica")),
        body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("ID visita: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["cardiologyVisitID"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("ID paziente: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child:
                                Text("${widget.visit["patientID"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("ID cardiologo: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child:
                                Text("${widget.visit["doctorID"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Tipo di dolore toracico: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["chestPainType"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Pressione sanguigna a riposo: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["restingBloodPressure"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Colesterolo: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["cholesterol"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Zuccheri nel sangue > 120 mg/dl: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(widget.visit["fastingBloodSugar"]
                                    ["value"]
                                ? "Sì"
                                : "No")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Elettrocardiogramma a riposo: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["restingElectrocardiographic"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Battiti cardiaci (max): ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["maxHeartRate"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Angina indotta: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(widget.visit["isAnginaInducted"]
                                ? "Sì"
                                : "No")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Depressione ST: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child:
                                Text("${widget.visit["oldPeakST"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Pendenza ST: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("${widget.visit["slopeST"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Numero di vasi colorati: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                                "${widget.visit["numberVesselColoured"]["value"]}")),
                      ])),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("Tipo difetto: ")),
                        Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text("${widget.visit["thal"]["value"]}")),
                      ])),
            ])));
  }
}
