import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pervasive_healthcare_app/API/generalpractitioner_requests.dart';
import 'package:pervasive_healthcare_app/components/my_drawer.dart';
import 'package:pervasive_healthcare_app/components/my_lists.dart';
import 'package:pervasive_healthcare_app/utils.dart' as utils;

class GeneralPractitionerPage extends StatefulWidget {
  GeneralPractitionerPage();

  @override
  _GeneralPractitionerPageState createState() =>
      _GeneralPractitionerPageState();
}

class _GeneralPractitionerPageState extends State<GeneralPractitionerPage> {
  List<String> appBarTitles = [
    "Informazioni mediche di base ",
    "Visite cardiologiche",
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
          future: (currentTab == 0)
              ? getMyInfo(utils.id, utils.token)
              : getMyCardiology(utils.id, utils.token),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
            icon: Icon(Icons.medical_services),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: '',
          ),
        ],
        currentIndex: currentTab,
        onTap: (value) {
          setState(() {
            this.appBarTitle = this.appBarTitles[value];
            this.currentTab = value;
          });
        },
      ),
    );
  }

  Widget getPage(int tab, Map<String, dynamic> data) {
    switch (tab) {
      case 0:
        return getGeneralPractitionerInfoPage(data);
        break;
      case 1:
        return getCardiologyVisitsPage(data);
        break;
      default:
        return Container();
    }
  }

  Widget getGeneralPractitionerInfoPage(
      Map<String, dynamic> generalPractitionerInfo) {
    if (generalPractitionerInfo == null || generalPractitionerInfo.isEmpty) {
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
      generalPractitionerInfo.containsKey("visits")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Visite: ${generalPractitionerInfo["visits"]["history"]}")
                ],
              ))
          : Container(),
      generalPractitionerInfo.containsKey("anamnesis")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Anamnesi: ${generalPractitionerInfo["anamnesis"]}")
                ],
              ))
          : Container(),
      generalPractitionerInfo.containsKey("bookingVisits")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Visite prenotate: ${generalPractitionerInfo["bookingVisits"]["history"]}")
                ],
              ))
          : Container(),
      generalPractitionerInfo.containsKey("prescriptions")
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Prescrizioni: ${generalPractitionerInfo["prescriptions"]["history"]}")
                ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Certificati medici: ${generalPractitionerInfo["medicalCertificateHistory"]["history"]}")
                ],
              ))
          : Container(),
    ]));
  }

  Widget getCardiologyVisitsPage(Map<String, dynamic> cardiologyVisits) {
    if (cardiologyVisits == null || cardiologyVisits.isEmpty) {
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
