import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pervasive_healthcare_app/utils.dart' as utils;
import 'package:menu_button/menu_button.dart';
import 'package:pervasive_healthcare_app/API/surgeon_requests.dart';
import 'package:pervasive_healthcare_app/views/login_page.dart';
import 'dart:async';
import 'package:pervasive_healthcare_app/components/my_lists.dart';

class SurgeonPage extends StatefulWidget {
  SurgeonPage();

  @override
  _SurgeonPageState createState() => _SurgeonPageState();
}

class _SurgeonPageState extends State<SurgeonPage> {
  var kinshipDegreeFuture = getKinshipDegree();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Le mie cartelle cliniche")),
      drawer: Drawer(
          child: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 50),
            child:
                Text("Pervasive Healthcare", style: TextStyle(fontSize: 20))),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Il tuo ID: ${utils.id}")),
        ListTile(
          title: Text("Logout"),
          onTap: () async {
            await logout(utils.token);
            utils.id = null;
            utils.token = null;
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return LoginPage();
            }));
          },
        )
      ])),
      body: FutureBuilder<List<dynamic>>(
          future: getMedicalRecords(utils.id, utils.token),
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
                                      Text("ID cartella clinica:"),
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${snapshot.data[i]["patientID"]["value"]}"),
                                  Text(
                                      "${snapshot.data[i]["medicalRecordID"]["value"]}"),
                                ],
                              )
                            ]),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return MedicalRecordDetailPage(snapshot.data[i]);
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
            var kinshipDegreeType = await kinshipDegreeFuture;
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return MedicalRecordInsertPage(kinshipDegreeType);
            }));
          }),
    );
  }
}

class MedicalRecordInsertPage extends StatefulWidget {
  List<dynamic> kinshipDegree;
  List<dynamic> surgeons;

  MedicalRecordInsertPage(this.kinshipDegree);

  @override
  _MedicalRecordInsertPageState createState() =>
      _MedicalRecordInsertPageState();
}

class _MedicalRecordInsertPageState extends State<MedicalRecordInsertPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController medicalRecordIDController = TextEditingController();
  TextEditingController doctorIDController = TextEditingController();
  TextEditingController doctorTreatmentController = TextEditingController();
  TextEditingController patientIDController = TextEditingController();
  TextEditingController hospitalizationMotivationController =
      TextEditingController();
  TextEditingController systemsInvestigationController =
      TextEditingController();
  TextEditingController familiarNameController = TextEditingController();
  TextEditingController familiarPhoneController = TextEditingController();
  TextEditingController pathologyNameController = TextEditingController();
  TextEditingController remoteInformationController = TextEditingController();
  TextEditingController physiologicInformationController =
      TextEditingController();
  TextEditingController healthEvolutionInfoController = TextEditingController();
  TextEditingController psychologicalStateController = TextEditingController();
  TextEditingController nutritionalStateController = TextEditingController();
  TextEditingController educationalStateController = TextEditingController();
  TextEditingController socialStateController = TextEditingController();

  TextEditingController diagnosticTreatmentDescrController =
      TextEditingController();
  TextEditingController therapeuticTreatmentDescrController =
      TextEditingController();
  TextEditingController rehabilitationTreatmentDescrController =
      TextEditingController();
  TextEditingController operatingReportsInterventionTypeController =
      TextEditingController();

  Map<int, String> kinshipeDegreeMap = {};
  Map<int, String> surgeonsMap = {};
  Map<int, String> severityMap = {
    0: 'Low disease',
    1: 'Changes life quality',
    2: 'Causes disability',
    3: 'Threatens life'
  };
  int kinshipDegreeSelectedIndex = 0;
  int surgeonSelectedIndex = 0;
  int severityIndex = 0;
  bool anamnesisController = false;
  bool initialAnalysisController = false;
  bool healthEvolutionController = false;
  bool diagnosticTreatmentsController = false;
  bool therapeuticTreatmentsController = false;
  bool rehabilitationTreatmentsController = false;
  bool clinicalDiaryController = false;
  int isClosedSelected = 0;
  List<int> isClosedChoice = [0, 1];
  List<bool> _isOpen;
  DateTime currentDate = DateTime.now();
  DateTime diagnosticTreatmentDateController;
  DateTime therapeuticTreatmentDateController;
  DateTime rehabilitationTreatmentDateController;

  @override
  void initState() {
    doctorIDController.text = utils.id;
    doctorTreatmentController.text = "000001";

    widget.kinshipDegree.forEach((element) {
      kinshipeDegreeMap[element["id"]] = element["value"];
    });
    super.initState();
  }

  Future<void> _selectDate(
      BuildContext context, DateTime dateController) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        dateController = currentDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inserisci cartella clinica"),
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
                    controller: medicalRecordIDController,
                    validator: (id) {
                      if (id == null || id.isEmpty) {
                        return "Campo obbligatorio";
                      }
                    },
                    decoration:
                        InputDecoration(labelText: "ID cartella clinica"),
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
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Column(
                        children: [
                          Text("Stato della cartella clinica"),
                          RadioListTile<int>(
                              value: 0,
                              groupValue: isClosedChoice[isClosedSelected],
                              title: Text("Aperta"),
                              onChanged: (value) {
                                setState(() {
                                  this.isClosedSelected = value;
                                });
                              }),
                          RadioListTile<int>(
                              value: 1,
                              groupValue: isClosedChoice[isClosedSelected],
                              title: Text("Chiusa"),
                              onChanged: (value) {
                                setState(() {
                                  this.isClosedSelected = value;
                                });
                              }),
                        ],
                      )),
                  ExpansionTile(
                    title: Text(
                      "Analisi iniziale",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ExpansionTile(
                        title: Text(
                          'Anamnesi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(
                              'Familiare',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            children: <Widget>[
                              TextFormField(
                                controller: familiarNameController,
                                validator: (id) {
                                  if ((anamnesisController) && id.isEmpty) {
                                    return "Campo obbligatorio";
                                  }
                                  if (id.isNotEmpty) {
                                    anamnesisController = true;
                                    initialAnalysisController = true;
                                  }
                                },
                                decoration:
                                    InputDecoration(labelText: "Nome Cognome"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  child: Row(children: [
                                    Text("Grado di parentela: "),
                                    MenuButton<int>(
                                      child: Container(
                                          width: 150,
                                          height: 30,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 6, left: 10),
                                              child: Text(kinshipeDegreeMap[
                                                  kinshipDegreeSelectedIndex]))),
                                      items: kinshipeDegreeMap.keys.toList(),
                                      itemBuilder: (int value) => Container(
                                        width: 150,
                                        height: 30,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 16),
                                        child: Text(kinshipeDegreeMap[value]),
                                      ),
                                      onItemSelected: (int value) {
                                        setState(() {
                                          kinshipDegreeSelectedIndex = value;
                                        });
                                      },
                                    )
                                  ])),
                              ExpansionTile(
                                title: Text(
                                  'Patologie pregresse',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  TextFormField(
                                    controller: pathologyNameController,
                                    validator: (id) {
                                      if ((anamnesisController) && id.isEmpty) {
                                        return "Campo obbligatorio";
                                      }
                                      if (id.isNotEmpty) {
                                        anamnesisController = true;
                                        initialAnalysisController = true;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Nome patologia"),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 18),
                                      child: Row(children: [
                                        Text("Grado di severità: "),
                                        MenuButton<int>(
                                          child: Container(
                                              width: 150,
                                              height: 30,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 6, left: 10),
                                                  child: Text(severityMap[
                                                      severityIndex]))),
                                          items: severityMap.keys.toList(),
                                          itemBuilder: (int value) => Container(
                                            width: 150,
                                            height: 30,
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 16),
                                            child: Text(severityMap[value]),
                                          ),
                                          onItemSelected: (int value) {
                                            setState(() {
                                              severityIndex = value;
                                            });
                                          },
                                        )
                                      ])),
                                ],
                              ),
                              TextFormField(
                                controller: familiarPhoneController,
                                validator: (id) {
                                  if ((anamnesisController) && id.isEmpty) {
                                    return "Campo obbligatorio";
                                  }
                                  if (id.isNotEmpty) {
                                    anamnesisController = true;
                                    initialAnalysisController = true;
                                  }
                                },
                                decoration:
                                    InputDecoration(labelText: "Cellulare"),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text(
                              'Remota',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            children: [
                              TextFormField(
                                controller: remoteInformationController,
                                validator: (id) {
                                  if ((anamnesisController) && id.isEmpty) {
                                    return "Campo obbligatorio";
                                  }
                                  if (id.isNotEmpty) {
                                    print("logged");
                                    anamnesisController = true;
                                    initialAnalysisController = true;
                                  }
                                },
                                decoration:
                                    InputDecoration(labelText: "Informazioni"),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text(
                              'Fisiologica',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            children: [
                              TextFormField(
                                controller: physiologicInformationController,
                                validator: (id) {
                                  if ((anamnesisController) && id.isEmpty) {
                                    return "Campo obbligatorio";
                                  }
                                  if (id.isNotEmpty) {
                                    anamnesisController = true;
                                    initialAnalysisController = true;
                                  }
                                },
                                decoration:
                                    InputDecoration(labelText: "Informazioni"),
                              ),
                            ],
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          'Esaminazione fisica',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          TextFormField(
                            controller: hospitalizationMotivationController,
                            validator: (id) {
                              if ((systemsInvestigationController
                                          .text.isNotEmpty ||
                                      anamnesisController) &&
                                  id.isEmpty) {
                                return "Campo obbligatorio";
                              }
                              if (id.isNotEmpty)
                                initialAnalysisController = true;
                            },
                            decoration: InputDecoration(
                                labelText: "Motivazione del ricovero"),
                          ),
                          TextFormField(
                            controller: systemsInvestigationController,
                            validator: (id) {
                              if ((hospitalizationMotivationController
                                          .text.isNotEmpty ||
                                      anamnesisController) &&
                                  id.isEmpty) {
                                return "Campo obbligatorio";
                              }
                              if (id.isNotEmpty)
                                initialAnalysisController = true;
                            },
                            decoration:
                                InputDecoration(labelText: "Investigazione"),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          'Valutazione dello stato',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          TextFormField(
                            controller: psychologicalStateController,
                            validator: (id) {
                              if ((nutritionalStateController.text.isNotEmpty ||
                                      educationalStateController
                                          .text.isNotEmpty ||
                                      socialStateController.text.isNotEmpty ||
                                      initialAnalysisController) &&
                                  id.isEmpty) {
                                return "Campo obbligatorio";
                              }
                              if (id.isNotEmpty)
                                initialAnalysisController = true;
                            },
                            decoration:
                                InputDecoration(labelText: "Psicologico"),
                          ),
                          TextFormField(
                            controller: nutritionalStateController,
                            validator: (id) {
                              if ((psychologicalStateController
                                          .text.isNotEmpty ||
                                      educationalStateController
                                          .text.isNotEmpty ||
                                      socialStateController.text.isNotEmpty ||
                                      initialAnalysisController) &&
                                  id.isEmpty) {
                                return "Campo obbligatorio";
                              }
                              if (id.isNotEmpty)
                                initialAnalysisController = true;
                            },
                            decoration:
                                InputDecoration(labelText: "Nutrizionale"),
                          ),
                          TextFormField(
                            controller: educationalStateController,
                            validator: (id) {
                              if ((nutritionalStateController.text.isNotEmpty ||
                                      psychologicalStateController
                                          .text.isNotEmpty ||
                                      socialStateController.text.isNotEmpty ||
                                      initialAnalysisController) &&
                                  id.isEmpty) {
                                return "Campo obbligatorio";
                              }
                              if (id.isNotEmpty)
                                initialAnalysisController = true;
                            },
                            decoration: InputDecoration(labelText: "Educativo"),
                          ),
                          TextFormField(
                            controller: socialStateController,
                            validator: (id) {
                              if ((nutritionalStateController.text.isNotEmpty ||
                                      educationalStateController
                                          .text.isNotEmpty ||
                                      psychologicalStateController
                                          .text.isNotEmpty ||
                                      initialAnalysisController) &&
                                  id.isEmpty) {
                                return "Campo obbligatorio";
                              }
                              if (id.isNotEmpty)
                                initialAnalysisController = true;
                            },
                            decoration: InputDecoration(labelText: "Sociale"),
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      "Diario clinico",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ExpansionTile(
                        title: Text(
                          "Evoluzione della salute",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          TextFormField(
                            controller: healthEvolutionInfoController,
                            validator: (id) {
                              if (id.isNotEmpty) {
                                clinicalDiaryController = true;
                                healthEvolutionController = true;
                              }
                            },
                            decoration:
                                InputDecoration(labelText: "Informazioni"),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          "Trattamenti diagnostici",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Text(currentDate.toString(),
                              style: TextStyle(fontSize: 18)),
                          RaisedButton(
                            onPressed: () => _selectDate(
                                context, diagnosticTreatmentDateController),
                            child: Text("Seleziona la data"),
                          ),
                          TextFormField(
                            controller: diagnosticTreatmentDescrController,
                            validator: (id) {
                              if (id.isNotEmpty) {
                                clinicalDiaryController = true;
                                diagnosticTreatmentsController = true;
                              }
                            },
                            decoration:
                                InputDecoration(labelText: "Descrizione"),
                          ),
                          TextFormField(
                            controller: doctorTreatmentController,
                            enabled: false,
                            decoration:
                                InputDecoration(labelText: "ID dottore"),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          "Trattamenti terapeutici",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Text(currentDate.toString(),
                              style: TextStyle(fontSize: 18)),
                          RaisedButton(
                            onPressed: () => _selectDate(
                                context, therapeuticTreatmentDateController),
                            child: Text("Seleziona la data"),
                          ),
                          TextFormField(
                            controller: therapeuticTreatmentDescrController,
                            validator: (id) {
                              if (id.isNotEmpty) {
                                clinicalDiaryController = true;
                                therapeuticTreatmentsController = true;
                              }
                            },
                            decoration:
                                InputDecoration(labelText: "Descrizione"),
                          ),
                          TextFormField(
                            controller: doctorTreatmentController,
                            enabled: false,
                            decoration:
                                InputDecoration(labelText: "ID dottore"),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          "Trattamenti riabilitativi",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Text(currentDate.toString(),
                              style: TextStyle(fontSize: 18)),
                          RaisedButton(
                            onPressed: () => _selectDate(
                                context, rehabilitationTreatmentDateController),
                            child: Text("Seleziona la data"),
                          ),
                          TextFormField(
                            controller: rehabilitationTreatmentDescrController,
                            validator: (id) {
                              if (id.isNotEmpty) {
                                clinicalDiaryController = true;
                                rehabilitationTreatmentsController = true;
                              }
                            },
                            decoration:
                                InputDecoration(labelText: "Descrizione"),
                          ),
                          TextFormField(
                            controller: doctorTreatmentController,
                            enabled: false,
                            decoration:
                                InputDecoration(labelText: "ID dottore"),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> insert() async {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> body = {};
      body["medicalRecordID"] = {"value": medicalRecordIDController.text};
      body["doctorID"] = {"value": doctorIDController.text};
      body["patientID"] = {"value": patientIDController.text};
      body["isClosed"] = isClosedSelected == 1 ? true : false;

      if (initialAnalysisController && anamnesisController) {
        body["initialAnalysis"] = {
          "anamnesi": {
            "familiars": {
              "familiars": [
                {
                  "name": familiarNameController.text,
                  "kinshipDegree": {
                    "id": kinshipDegreeSelectedIndex,
                    "value": kinshipeDegreeMap[kinshipDegreeSelectedIndex]
                  },
                  "previousPathologies": {
                    "pathologies": [
                      {
                        "pathologyName": {
                          "value": pathologyNameController.text
                        },
                        "detectionDate": {
                          "value": utils.localDate.format(DateTime.now())
                        },
                        "pathologySeverity": {
                          "description": severityMap[severityIndex],
                          "severity": {
                            "id": severityIndex,
                            "value": severityIndex == 0
                                ? "ONE"
                                : severityIndex == 1
                                    ? "TWO"
                                    : severityIndex == 2
                                        ? "THREE"
                                        : "FOUR"
                          }
                        }
                      }
                    ]
                  },
                  "phoneNumber": familiarPhoneController.text
                }
              ]
            },
            "remotes": {
              "history": [
                {
                  "info": remoteInformationController.text,
                  "date": utils.localDate.format(DateTime.now())
                }
              ]
            },
            "physiologic": {
              "info": physiologicInformationController.text,
              "date": utils.localDate.format(DateTime.now())
            }
          },
          "physicalExamination": {
            "hospitalizationMotivation": {
              "value": hospitalizationMotivationController.text
            },
            "systemsInvestigation": {
              "value": systemsInvestigationController.text
            }
          },
          "stateEvaluation": {
            "psychological": {"value": psychologicalStateController.text},
            "nutritional": {"value": nutritionalStateController.text},
            "educational": {"value": educationalStateController.text},
            "social": {"value": socialStateController.text}
          }
        };
      } else if (initialAnalysisController) {
        body["initialAnalysis"] = {
          "physicalExamination": {
            "hospitalizationMotivation": {
              "value": hospitalizationMotivationController.text
            },
            "systemsInvestigation": {
              "value": systemsInvestigationController.text
            }
          },
          "stateEvaluation": {
            "psychological": {"value": psychologicalStateController.text},
            "nutritional": {"value": nutritionalStateController.text},
            "educational": {"value": educationalStateController.text},
            "social": {"value": socialStateController.text}
          }
        };
      }
      if (clinicalDiaryController) {
        body["clinicalDiary"] = {
          if (healthEvolutionController)
            {
              "healthEvolution": {
                "info": {"value": healthEvolutionInfoController.text},
                "dateTime": utils.localDate.format(DateTime.now())
              },
            },
          if (diagnosticTreatmentsController)
            {
              "diagnosticTreatments": {
                "diagnosticTreatments": [
                  {
                    "treatment": {
                      "date": utils.localDate
                          .format(diagnosticTreatmentDateController),
                      "description": {
                        "value": diagnosticTreatmentDescrController.text
                      },
                      "doctorID": {"value": doctorTreatmentController.text}
                    }
                  }
                ]
              },
            },
          if (therapeuticTreatmentsController)
            {
              "therapeuticTreatments": {
                "therapeuticTreatments": [
                  {
                    "treatment": {
                      "date": utils.localDate
                          .format(therapeuticTreatmentDateController),
                      "description": {
                        "value": therapeuticTreatmentDescrController.text
                      },
                      "doctorID": {"value": doctorTreatmentController.text}
                    }
                  }
                ]
              },
            },
          if (rehabilitationTreatmentsController)
            {
              "rehabilitationTreatments": {
                "rehabilitationTreatments": [
                  {
                    "treatment": {
                      "date": utils.localDate
                          .format(rehabilitationTreatmentDateController),
                      "description": {
                        "value": rehabilitationTreatmentDescrController.text
                      },
                      "doctorID": {"value": doctorTreatmentController.text}
                    }
                  }
                ]
              }
            }
        };
      }

      Map<String, dynamic> response =
          await insertMedicalRecord(body, utils.token);
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
            return SurgeonPage();
          }));
        });
      }
    }
  }
}

class MedicalRecordDetailPage extends StatefulWidget {
  Map<String, dynamic> medicalrecord;

  MedicalRecordDetailPage(this.medicalrecord);
  @override
  _MedicalRecordDetailPageState createState() =>
      _MedicalRecordDetailPageState(this.medicalrecord);
}

class _MedicalRecordDetailPageState extends State<MedicalRecordDetailPage> {
  Map<String, dynamic> detailmedicalrecord;

  Map<String, dynamic> initialAnalysis;
  _MedicalRecordDetailPageState(medicalrecord) {
    detailmedicalrecord = medicalrecord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Cartella clinica",
        )),
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text("ID cartella clinica: ")),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                          "${widget.medicalrecord["medicalRecordID"]["value"]}")),
                ])),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text("ID paziente: ")),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                          "${widget.medicalrecord["patientID"]["value"]}")),
                ])),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text("ID medico: ")),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child:
                          Text("${widget.medicalrecord["doctorID"]["value"]}")),
                ])),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text("Stato: ")),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                          ("${widget.medicalrecord["isClosed"]}") == "true"
                              ? "Chiusa"
                              : "Aperta")),
                ])),
            detailmedicalrecord.containsKey("initialAnalysis")
                ? detailmedicalrecord["initialAnalysis"]
                        .containsKey("anamnesis")
                    ? Column(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    "Mostra anamnesi familiari",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                          scrollable: true,
                                          title: Center(
                                              child: Text(
                                            "Anamnesi familiari",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          content: Container(
                                            width: 300,
                                            height: 200,
                                            child: getFamiliarAnamnesis(
                                                detailmedicalrecord[
                                                        "initialAnalysis"]
                                                    ["anamnesis"]["familiars"]),
                                          ));
                                    }),
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Center(
                                    child: Text(
                                  "Mostra anamnesi remote",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                          scrollable: true,
                                          title: Center(
                                              child: Text(
                                            "Anamnesi remote",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          content: Container(
                                            width: 300,
                                            height: 200,
                                            child: getRemotesAnamnesis(
                                                detailmedicalrecord[
                                                        "initialAnalysis"]
                                                    ["anamnesis"]["remotes"]),
                                          ));
                                    }),
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Anamnesi fisiologica: ",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                          "Informazioni: ${detailmedicalrecord["initialAnalysis"]["anamnesis"]["physiologic"]["info"]}"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(
                                          "Data: ${detailmedicalrecord["initialAnalysis"]["anamnesis"]["physiologic"]["date"]}"),
                                    ),
                                  ])),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Nessuna anamnesi inserita",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Text(
                                              "Esaminazione fisica: ",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Motivazione ricovero: ${detailmedicalrecord["initialAnalysis"]["physicalExamination"]["hospitalizationMotivation"]["value"]}"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                              "Investigazione: ${detailmedicalrecord["initialAnalysis"]["physicalExamination"]["systemsInvestigation"]["value"]}"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      "Nessuna analisi iniziale inserita",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
            if (detailmedicalrecord.containsKey("clinicalDiary"))
              (Column(children: [
                detailmedicalrecord["clinicalDiary"]
                        .containsKey("healthEvolution")
                    ? (Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Evoluzione della salute: ",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                      "Informazioni: ${detailmedicalrecord["clinicalDiary"]["healthEvolution"]["info"]["value"]}"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                      "Data: ${detailmedicalrecord["clinicalDiary"]["healthEvolution"]["dateTime"]}"),
                                )
                              ],
                            ),
                          ),
                        ],
                      ))
                    : Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Nessuna analisi iniziale inserita",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                detailmedicalrecord["clinicalDiary"]
                        .containsKey("diagnosticTreatments")
                    ? (Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            "Trattamenti diagnostici:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )),
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                    scrollable: true,
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getDiagnosticTreatments(
                                          detailmedicalrecord["clinicalDiary"]
                                                  ["diagnosticTreatments"]
                                              ["diagnosticTreatments"]),
                                    ));
                              }),
                        ),
                      ))
                    : Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Nessun trattamento diagnostio inserito",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                detailmedicalrecord["clinicalDiary"]
                        .containsKey("therapeuticTreatments")
                    ? (Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            "Trattamenti terapeutici:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )),
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                    scrollable: true,
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getTherapeuticTreatments(
                                          detailmedicalrecord["clinicalDiary"]
                                                  ["therapeuticTreatments"]
                                              ["therapeuticTreatments"]),
                                    ));
                              }),
                        ),
                      ))
                    : Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Nessun trattamento terapeutico inserito",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                detailmedicalrecord["clinicalDiary"]
                        .containsKey("rehabilitationTreatments")
                    ? (Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            "Trattamenti riabilitativi:",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          )),
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                    scrollable: true,
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getRehabilitationTreatments(
                                          detailmedicalrecord["clinicalDiary"]
                                                  ["rehabilitationTreatments"]
                                              ["rehabilitationTreatments"]),
                                    ));
                              }),
                        ),
                      ))
                    : Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "Nessun trattamento riabilitativo inserito",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
              ]))
            else
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  "Nessun diario clinico inserito",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
          ]),
        ));
  }
}
