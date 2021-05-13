import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pervasive_healthcare_app/API/patient_requests.dart';
import 'package:pervasive_healthcare_app/components/my_drawer.dart';
import 'package:pervasive_healthcare_app/components/my_lists.dart';
import 'package:pervasive_healthcare_app/utils.dart' as utils;
import 'package:pervasive_healthcare_app/views/surgeon_page.dart';

class PatientPage extends StatefulWidget {
  PatientPage();

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  Future<Map<String, dynamic>> myInfoFuture = getMyInfo(utils.id, utils.token);

  List<String> appBarTitles = [
    "I tuoi dati",
    "Le tue informazioni mediche",
    "Le tue cartelle cliniche",
    "Le info del medico di base",
    "Le tue visite cardiologiche"
  ];
  String appBarTitle;
  int currentTab = 0;

  @override
  void initState() {
    appBarTitle = appBarTitles[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      drawer: getDrawer(context),
      body: FutureBuilder(
          future: myInfoFuture,
          builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return getPage(currentTab, snapshot.data);

                break;
              default:
                return CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.heartbeat, size: 22),
            label: '',
          ),
        ],
        currentIndex: currentTab,
        onTap: (value) {
          setState(() {
            this.appBarTitle = this.appBarTitles[value];
            this.currentTab = value;
            myInfoFuture = getMyInfo(utils.id, utils.token);
          });
        },
      ),
    );
  }

  Widget getPage(int tab, Map<String, dynamic> data) {
    switch (tab) {
      case 0:
        return getDataPage(data);
        break;
      case 1:
        return getGeneralInfoPage(data["generalInfo"]);
        break;
      case 2:
        return getMedicalRecordsPage(data["medicalRecords"]);
        break;
      case 3:
        return getGeneralPractitionerInfoPage(data["generalPractitionerInfo"]);
        break;
      case 4:
        return getCardiologyVisitsPage(data["cardiologyVisitHistory"]);
        break;
      default:
        return Container();
    }
  }

  Widget getDataPage(Map<String, dynamic> data) {
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          padding: EdgeInsets.only(bottom: 8, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("ID paziente: ${data["patientID"]["value"]}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Codice fiscale: ${data["cf"]["value"]}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nome e cognome: ${data["name"]} ${data["surname"]}")
            ],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Data e luogo di nascita: ${utils.stringDate.format(DateTime.parse(data["birthDate"]))}, ${data["birthplace"]}")
            ],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Sesso: ${data["gender"]["value"]}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Telefono: ${data["phone"]}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Cellulare: ${data["mobilePhone"] ?? ""}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Indirizzo: ${data["address"]}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Residenza: ${data["residenceAddress"]}, ${data["residenceCity"]} (${data["province"]}) ")
            ],
          ))
    ]));
  }

  Widget getGeneralInfoPage(Map<String, dynamic> generalInfo) {
    if (generalInfo.isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child: Text("Non hai ancora nessuna informazione inserita"),
          ));
    }
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          padding: EdgeInsets.only(bottom: 8, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Gruppo sanguigno: ${generalInfo["bloodGroup"]["bloodType"]["value"]} RH ${generalInfo["bloodGroup"]["rh"]["value"]}")
            ],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Peso: ${generalInfo["weight"]["value"]}")],
          )),
      Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Altezza: ${generalInfo["height"]["value"]}")],
          )),
      generalInfo.containsKey("allergies")
          ? ListTile(
              title: Text("Mostra allergie"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Allergie"),
                        content:
                            getAllergies(generalInfo["allergies"]["allergies"]),
                      );
                    });
              },
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Nessuna allergia"),
            ),
      generalInfo.containsKey("previousPathologies")
          ? ListTile(
              title: Text("Mostra patologie pregresse"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Patologie pregresse"),
                        content: getPreviousPathologies(
                            generalInfo["previousPathologies"]["pathologies"]),
                      );
                    });
              },
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Nessuna patologia pregressa"),
            ),
      generalInfo.containsKey("prescriptionHistory")
          ? ListTile(
              title: Text("Mostra storico prescrizioni"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Prescrizioni"),
                        content: getPrescriptions(
                            generalInfo["prescriptionHistory"]["history"]),
                      );
                    });
              },
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Nessuna prescrizione da visualizzare"),
            ),
      generalInfo.containsKey("examHistory")
          ? ListTile(
              title: Text("Mostra storico esami"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Esami"),
                        content:
                            getExams(generalInfo["examHistory"]["history"]),
                      );
                    });
              },
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Nessuna esame effettuato"),
            )
    ]));
  }

  Widget getMedicalRecordsPage(Map<String, dynamic> medicalRecords) {
    if (medicalRecords["history"].isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child: Text("Non hai ancora nessuna cartella clinica inserita"),
          ));
    }
    return ListView.builder(
        itemCount: medicalRecords["history"].length,
        itemBuilder: (_, i) {
          return InkWell(
              onTap: () {
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MedicalRecordDetailPage(
                            medicalRecords["history"][i])));
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "ID cartella clinica: ${medicalRecords["history"][i]["medicalRecordID"]["value"]}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "ID creatore: ${medicalRecords["history"][i]["doctorID"]["value"]}")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Chiusa: ${medicalRecords["history"][i]["isClosed"] ? "Sì" : "No"}")
                        ],
                      ),
                      Container(height: 5),
                      Divider(thickness: 1, height: 0)
                    ],
                  )));
        });
  }

  Widget getGeneralPractitionerInfoPage(
      Map<String, dynamic> generalPractitionerInfo) {
    if (generalPractitionerInfo.isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child: Text("Non hai ancora nessuna informazione inserita"),
          ));
    }
    return SingleChildScrollView(
        child: Column(children: [
      Container(
          padding: EdgeInsets.only(bottom: 8, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "ID dottore: ${generalPractitionerInfo["doctorID"]["value"]}")
            ],
          )),
      generalPractitionerInfo.containsKey("anamnesis")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra anamnesi familiare")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Anamnesi familiare")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getFamiliarAnamnesis(
                                generalPractitionerInfo["anamnesis"]
                                    ["familiars"]["familiars"]),
                          ));
                    }),
              ))
          : Container(),
      generalPractitionerInfo.containsKey("anamnesis")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra anamnesi remota")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Anamnesi remota")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getRemotesAnamnesis(
                                generalPractitionerInfo["anamnesis"]["remotes"]
                                    ["history"]),
                          ));
                    }),
              ))
          : Container(),
      generalPractitionerInfo.containsKey("visits")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra visite")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Visite")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getVisits(
                                generalPractitionerInfo["visits"]["history"]),
                          ));
                    }),
              ))
          : Container(),
      generalPractitionerInfo.containsKey("bookingVisits")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra prenotazioni")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Prenotazioni")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getBookingHistory(
                                generalPractitionerInfo["bookingVisits"]
                                    ["history"]),
                          ));
                    }),
              ))
          : Container(),
      generalPractitionerInfo.containsKey("prescriptions")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra prescrizioni")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Prescrizioni")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getPrescriptions(
                                generalPractitionerInfo["prescriptions"]
                                    ["history"]),
                          ));
                    }),
              ))
          : Container(),
      generalPractitionerInfo.containsKey("therapies")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra terapie")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Terapie")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getTherapies(
                                generalPractitionerInfo["therapies"]
                                    ["history"]),
                          ));
                    }),
              ))
          : Container(),
      generalPractitionerInfo.containsKey("medicalCertificateHistory")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Center(child: Text("Mostra certificati")),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          title: Center(child: Text("Certificati")),
                          content: Container(
                            width: 300,
                            height: 200,
                            child: getMedicalCertificates(
                                generalPractitionerInfo[
                                    "medicalCertificateHistory"]["history"]),
                          ));
                    }),
              ))
          : Container(),
    ]));
  }

  Widget getCardiologyVisitsPage(Map<String, dynamic> cardiologyVisits) {
    if (cardiologyVisits.isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child: Text("Non hai ancora nessuna visita inserita"),
          ));
    }
    return ListView.builder(
        itemCount: cardiologyVisits["history"].length,
        itemBuilder: (_, i) {
          var elem = cardiologyVisits["history"][i];
          return ListTile(
            title: Column(
              children: [
                Text("ID dottore: ${elem["doctorID"]["value"]}"),
                Text("ID visita: ${elem["cardiologyVisitID"]["value"]}")
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      scrollable: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      title: Center(child: Text("Visita cardiologica")),
                      content: SingleChildScrollView(
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                        "ID medico: ${elem["doctorID"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "ID visita: ${elem["cardiologyVisitID"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Tipo di dolore: ${elem["chestPainType"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Pressione sanguigna: ${elem["restingBloodPressure"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Colesterolo: ${elem["cholesterol"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Concentrazione zuccheri > 120mg/dl: ${elem["fastingBloodSugar"]["value"] ? "Sì" : "No"}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Valore ECG: ${elem["restingElectrocardiographic"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Battiti cardiaci (max): ${elem["maxHeartRate"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Angina indotta: ${elem["isAnginaInducted"] ? "Sì" : "No"}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Vecchio picco: ${elem["oldPeakST"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Pendenza ST: ${elem["slopeST"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Numero vasi colorati: ${elem["numberVesselColoured"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Tipo difetto: ${elem["thal"]["value"]}",
                                        overflow: TextOverflow.clip),
                                    Text(
                                        "Data visita: ${elem["visitDate"]["visitDate"]}",
                                        overflow: TextOverflow.clip),
                                  ],
                                )
                              ]),
                          Container(height: 5),
                          Divider(height: 1, thickness: 1)
                        ]),
                      ),
                    );
                  });
            },
          );
        });
  }
}
