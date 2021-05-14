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
    "Predizioni cardiologiche",
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
          builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
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

  Widget getPage(int tab, List<dynamic> data) {
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

  Widget getGeneralPractitionerInfoPage(List<dynamic> generalPractitionerInfo) {
    if (generalPractitionerInfo == null || generalPractitionerInfo.isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child: Text("Non hai ancora nessuna informazione inserita"),
          ));
    } else {
      return ListView.builder(
          itemCount: generalPractitionerInfo.length,
          itemBuilder: (_, i) {
            return ListTile(
              title: Column(
                children: [
                  Text("Info"),
                  Text(
                      "ID paziente: ${generalPractitionerInfo[i]["patientID"]["value"]}"),
                  generalPractitionerInfo[i].containsKey("visits")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title: Center(child: Text("Mostra visite")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    title:
                                        Center(child: Text("Visite paziente")),
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getVisits(
                                          generalPractitionerInfo[i]["visits"]
                                              ["history"]),
                                    ))),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Nessuna visita inserita")],
                          )),
                  generalPractitionerInfo[i].containsKey("anamnesis")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title: Center(
                                child: Text("Mostra anamnesi familiare")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    title: Center(
                                        child: Text("Anamnesi familiare")),
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getFamiliarAnamnesis(
                                          generalPractitionerInfo[i]
                                                  ["anamnesis"]["familiars"]
                                              ["familiars"]),
                                    ))),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nessuna anamnesi familiare inserita")
                            ],
                          )),
                  generalPractitionerInfo[i].containsKey("anamnesis")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title: Center(
                                child: Text("Mostra anamnesi fisiologica")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    title: Center(
                                        child: Text("Anamnesi fisiologica")),
                                    content: Container(
                                        width: 300,
                                        height: 200,
                                        child: Column(children: [
                                          Text(
                                              "Data: ${generalPractitionerInfo[i]["anamnesis"]["physiologic"]["date"]}"),
                                          Text(
                                              "Data: ${generalPractitionerInfo[i]["anamnesis"]["physiologic"]["info"]}")
                                        ])))),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nessuna anamnesi remota inserita")
                            ],
                          )),
                  generalPractitionerInfo[i].containsKey("anamnesis")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title:
                                Center(child: Text("Mostra anamnesi remota")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    title:
                                        Center(child: Text("Anamnesi remota")),
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getRemotesAnamnesis(
                                          generalPractitionerInfo[i]
                                                  ["anamnesis"]["remotes"]
                                              ["history"]),
                                    ))),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nessuna anamnesi remota inserita")
                            ],
                          )),
                  generalPractitionerInfo[i].containsKey("bookingVisits")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title:
                                Center(child: Text("Mostra visite prenotate")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    title:
                                        Center(child: Text("Visite prenotate")),
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getBookingHistory(
                                          generalPractitionerInfo[i]
                                              ["bookingVisits"]["history"]),
                                    ))),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Nessuna visita prenotata")],
                          )),
                  generalPractitionerInfo[i].containsKey("prescriptions")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title: Center(child: Text("Mostra prescrizioni")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    title: Center(child: Text("Prescrizioni")),
                                    content: Container(
                                      width: 300,
                                      height: 200,
                                      child: getPrescriptions(
                                          generalPractitionerInfo[i]
                                              ["prescriptions"]["history"]),
                                    ))),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Nessuna prescrizione inserita")],
                          )),
                  generalPractitionerInfo[i].containsKey("therapies")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
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
                                            generalPractitionerInfo[i]
                                                ["therapies"]["history"]),
                                      ));
                                }),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Nessuna terapia inserita")],
                          )),
                  generalPractitionerInfo[i]
                          .containsKey("medicalCertificateHistory")
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: ListTile(
                            title: Center(child: Text("Mostra certificati")),
                            onTap: () => showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      scrollable: true,
                                      title: Center(
                                          child: Text("Certificati medici")),
                                      content: Container(
                                        width: 300,
                                        height: 200,
                                        child: getMedicalCertificates(
                                            generalPractitionerInfo[i][
                                                    "medicalCertificateHistory"]
                                                ["history"]),
                                      ));
                                }),
                          ))
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Nessun certificato medico inserita")
                            ],
                          )),
                ],
              ),
              /*
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                          scrollable: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          title: Center(child: Text("Info")),
                          content: SingleChildScrollView(
                              child: Column(children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 8, top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text("ID dottore: ${utils.id}")],
                                )),
                            generalPractitionerInfo[i].containsKey("visits")
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                        children: getVisitWidgets(
                                            generalPractitionerInfo[i]["visits"]
                                                ["history"])))
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Nessuna visita inserita")
                                      ],
                                    )),
                            generalPractitionerInfo[i].containsKey("anamnesis")
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                        children: getVisitWidgets(
                                            generalPractitionerInfo[i]
                                                ["anamnesis"]["familiar"])))
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Nessuna anamnesi inserita")
                                      ],
                                    )),
                            generalPractitionerInfo[i]
                                    .containsKey("bookingVisits")
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Visite prenotate: ${generalPractitionerInfo[i]["bookingVisits"]["history"]}")
                                      ],
                                    ))
                                : Container(),
                            generalPractitionerInfo[i]
                                    .containsKey("prescriptions")
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Prescrizioni: ${generalPractitionerInfo[i]["prescriptions"]["history"]}")
                                      ],
                                    ))
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Nessuna prescrizione inserita")
                                      ],
                                    )),
                            generalPractitionerInfo[i].containsKey("therapies")
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      title:
                                          Center(child: Text("Mostra terapie")),
                                      onTap: () => showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                                scrollable: true,
                                                title: Center(
                                                    child: Text("Terapie")),
                                                content: Container(
                                                  width: 300,
                                                  height: 200,
                                                  child: getTherapies(
                                                      generalPractitionerInfo[i]
                                                              ["therapies"]
                                                          ["history"]),
                                                ));
                                          }),
                                    ))
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Nessuna terapia inserita")
                                      ],
                                    )),
                            generalPractitionerInfo[i]
                                    .containsKey("medicalCertificateHistory")
                                ? Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Certificati medici: ${generalPractitionerInfo[i]["medicalCertificateHistory"]["history"]}")
                                      ],
                                    ))
                                : Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Nessun certificato medico inserita")
                                      ],
                                    )),
                          ])));
                    },
                  );*/
            );
          });
    }
  }

  Widget getCardiologyVisitsPage(List<dynamic> cardiologyVisits) {
    if (cardiologyVisits == null || cardiologyVisits.isEmpty) {
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Center(
            child:
                Text("Non hai ancora nessuna predizione di malattia inserita"),
          ));
    } else {
      return ListView.builder(
          itemCount: cardiologyVisits.length,
          itemBuilder: (_, i) {
            Map<String, dynamic> elem = cardiologyVisits[i]["cardiologyVisit"];
            return ListTile(
              title: Column(
                children: [
                  Text(
                      "ID paziente: ${cardiologyVisits[i]["patientID"]["value"]}"),
                  Text("ATTENZIONE! POSSIBILITA' DI MALATTIA CARDIACA!",
                      textAlign: TextAlign.center)
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
                                          "ID medico: ${cardiologyVisits[i]["doctorID"]["value"]}",
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
}
