import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/****************GENERAL INFO ************************/
Widget getAllergies(List<dynamic> allergies) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: allergies.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "Tipo di allergia: ${allergies[i]["allergyClass"]["value"]}"),
                Text("Descrizione: ${allergies[i]["description"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getPreviousPathologies(List<dynamic> pathologies) {
  return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: pathologies.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "Nome patologia: ${pathologies[i]["pathologyName"]["value"]}"),
                Text(
                    "Data di diagnosi: ${pathologies[i]["detectionDate"]["value"]}"),
                Text(
                    "Descrizione: ${pathologies[i]["pathologySeverity"]["description"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getPrescriptions(List<dynamic> prescriptions) {
  //Also for general practitioner info
  return ListView.builder(
      shrinkWrap: true,
      itemCount: prescriptions.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "Data prescrizione: ${prescriptions[i]["prescriptionDate"]["value"]}"),
                Text(
                    "Informazioni: ${prescriptions[i]["prescriptionInfo"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getExams(List<dynamic> exams) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: exams.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Data esame: ${exams[i]["examDate"]["value"]}"),
                Text("Report: ${exams[i]["examReport"]["value"]}"),
                Text("Informazioni: ${exams[i]["examInfo"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

/********************** MEDICAL RECORDS **********************/

Widget getDiagnosticServicesRequests(List<dynamic> dsRequests) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: dsRequests.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("ID richiesta: ${dsRequests[i]["id"]["id"]}"),
                Text("ID dottore: ${dsRequests[i]["doctorID"]["value"]}"),
                Text("Descrizione: ${dsRequests[i]["description"]["value"]}"),
                Text("Form: ${dsRequests[i]["form"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getVitalSigns(List<dynamic> vitalSigns) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: vitalSigns.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Info: ${vitalSigns[i]["info"]["value"]}"),
                Text("Data e ora: ${vitalSigns[i]["datetime"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getPainReliefs(List<dynamic> painReliefs) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: painReliefs.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Data e ora: ${painReliefs[i]["datetime"]}"),
                Text("Descrizione: ${painReliefs[i]["description"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getDrugsPrescriptions(List<dynamic> drugPrescriptions) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: drugPrescriptions.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "ID dottore: ${drugPrescriptions[i]["doctorID"]["value"]}"),
                Text(
                    "Descrizione: ${drugPrescriptions[i]["description"]["value"]}"),
                Text("Data e ora: ${drugPrescriptions[i]["datetime"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getDrugsAdministered(List<dynamic> drugAdministered) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: drugAdministered.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("ID dottore: ${drugAdministered[i]["doctorID"]["value"]}"),
                Text(
                    "Descrizione: ${drugAdministered[i]["description"]["value"]}"),
                Text("Data e ora: ${drugAdministered[i]["datetime"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getReports(List<dynamic> reports) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: reports.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "Attività diagnostica: ${reports[i]["activity"]["diagnostics"]["value"]}"),
                Text(
                    "Attività consultiva: ${reports[i]["activity"]["consulting"]["value"]}"),
                Text(
                    "Attività rlascio terapia: ${reports[i]["activity"]["therapeuticDelivery"]["value"]}"),
                Text(
                    "Attività riabilitativa: ${reports[i]["activity"]["rehabilitation"]["value"]}"),
                Text(
                    "Attività assistenza: ${reports[i]["activity"]["assistance"]["value"]}"),
                Text(
                    "Tipo trattamento: ${reports[i]["treatmentType"]["value"]}"),
                Text("Data e ora: ${reports[i]["datetime"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getMedicalSurgicalDevice(List<dynamic> devices) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: devices.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Nome strumento: ${devices[i]["name"]}"),
                Text("Etichetta: ${devices[i]["label"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

/**********************GENERAL PRACTITIONER INFO ****************************/

Widget getVisits(List<dynamic> visits) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: visits.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Data visita: ${visits[i]["visitDate"]["visitDate"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getBookingHistory(List<dynamic> bookingVisits) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: bookingVisits.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("ID prenotazione: ${bookingVisits[i]["bookingId"]}"),
                Text(
                    "Data visita: ${bookingVisits[i]["visit"]["visitDate"]["visitDate"]}"),
                Text(
                    "Descrizione: ${bookingVisits[i]["description"]["value"]}"),
                Text("Data prenotazione: ${bookingVisits[i]["bookingData"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getTherapies(List<dynamic> therapies) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: therapies.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "Data creazione: ${therapies[i]["therapyDate"]["therapyDate"]}"),
                Text(
                    "Descrizione: ${therapies[i]["therapyDescription"]["therapyDescription"]}"),
                Text(
                    "Data di inizio: ${therapies[i]["therapyInitialDate"]["therapyInitialDate"]}"),
                therapies[i].containsKey("therapyFinalDate")
                    ? Text(
                        "Data di fine: ${therapies[i]["therapyFinalDate"]["therapyFinalDate"]}")
                    : Container(),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getMedicalCertificates(List<dynamic> medicalCertificates) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: medicalCertificates.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "ID certificato medico: ${medicalCertificates[i]["medicalCertificateID"]["value"]}"),
                Icon(Icons.image)
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getFamiliarAnamnesis(List<dynamic> familiarAnamnesis) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: familiarAnamnesis.length,
      itemBuilder: (_, i) {
        List<Widget> widgets = [
          Text("Nome Cognome: ${familiarAnamnesis[i]["name"]}"),
          Text(
              "Grado di parentela: ${familiarAnamnesis[i]["kinshipDegree"]["value"]}"),
          Text("PATOLOGIE")
        ];
        widgets.add(Column(
          children: (familiarAnamnesis[i]["previousPathologies"]["pathologies"]
                  as List<dynamic>)
              .map((e) => Column(
                    children: [
                      Text("Nome patologia: ${e["pathologyName"]["value"]}"),
                      Text("Data di diagnosi: ${e["detectionDate"]["value"]}"),
                      Text(
                          "Descrizione: ${e["pathologySeverity"]["description"]}"),
                    ],
                  ))
              .toList(),
        ));
        widgets.add(
            Text("Numero di telefono: ${familiarAnamnesis[i]["phoneNumber"]}"));
        return Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Column(children: widgets)]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getRemotesAnamnesis(List<dynamic> remoteAnamnesis) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: remoteAnamnesis.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Informazioni: ${remoteAnamnesis[i]["info"]}"),
                Text("Data: ${remoteAnamnesis[i]["date"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getDiagnosticTreatments(List<dynamic> diagnosticTreatments) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: diagnosticTreatments.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Data: ${diagnosticTreatments[i]["treatment"]["date"]}"),
                Text(
                    "Descrizione: ${diagnosticTreatments[i]["treatment"]["description"]["value"]}"),
                Text(
                    "ID medico: ${diagnosticTreatments[i]["treatment"]["doctorID"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getTherapeuticTreatments(List<dynamic> therapeuticTreatments) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: therapeuticTreatments.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("Data: ${therapeuticTreatments[i]["treatment"]["date"]}"),
                Text(
                    "Descrizione: ${therapeuticTreatments[i]["treatment"]["description"]["value"]}"),
                Text(
                    "ID medico: ${therapeuticTreatments[i]["treatment"]["doctorID"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

Widget getRehabilitationTreatments(List<dynamic> rehabilitationTreatments) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: rehabilitationTreatments.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text(
                    "Data: ${rehabilitationTreatments[i]["treatment"]["date"]}"),
                Text(
                    "Descrizione: ${rehabilitationTreatments[i]["treatment"]["description"]["value"]}"),
                Text(
                    "ID medico: ${rehabilitationTreatments[i]["treatment"]["doctorID"]["value"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}

/**********************CARDIOLOGY VISITS ***************************************/

Widget getCardiologyVisitsHistory(List<dynamic> cardiologyVisits) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: cardiologyVisits.length,
      itemBuilder: (_, i) {
        return Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: [
                Text("ID medico: ${cardiologyVisits[i]["doctorID"]["value"]}"),
                Text(
                    "ID visita: ${cardiologyVisits[i]["cardiologyVisitID"]["value"]}"),
                Text(
                    "Tipo di dolore: ${cardiologyVisits[i]["chestPainType"]["value"]}"),
                Text(
                    "Pressione sanguigna: ${cardiologyVisits[i]["restingBloodPressure"]["value"]}"),
                Text(
                    "Colesterolo: ${cardiologyVisits[i]["cholesterol"]["value"]}"),
                Text(
                    "Concentrazione zuccheri > 120mg/dl: ${cardiologyVisits[i]["fastingBloodSugar"]["value"] ? "Sì" : "No"}"),
                Text(
                    "Valore ECG: ${cardiologyVisits[i]["restingElectrocardiographic"]["value"]}"),
                Text(
                    "Battiti cardiaci (max): ${cardiologyVisits[i]["maxHeartRate"]["value"]}"),
                Text(
                    "Angina indotta: ${cardiologyVisits[i]["isAnginaInducted"] ? "Sì" : "No"}"),
                Text(
                    "Vecchio picco: ${cardiologyVisits[i]["oldPeakST"]["value"]}"),
                Text("Pendenza ST: ${cardiologyVisits[i]["slopeST"]["value"]}"),
                Text(
                    "Numero vasi colorati: ${cardiologyVisits[i]["numberVesselColoured"]["value"]}"),
                Text("Tipo difetto: ${cardiologyVisits[i]["thal"]["value"]}"),
                Text(
                    "Data visita: ${cardiologyVisits[i]["visitDate"]["visitDate"]}"),
              ],
            )
          ]),
          Container(height: 5),
          Divider(height: 1, thickness: 1)
        ]);
      });
}
