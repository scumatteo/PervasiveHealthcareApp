import 'package:flutter/material.dart';
import 'package:pervasive_healthcare_app/API/cardiologist_requests.dart';

class CardiologistPage extends StatefulWidget {
  String id;
  String token;

  CardiologistPage(this.id, this.token);

  @override
  _CardiologistPageState createState() => _CardiologistPageState();
}

class _CardiologistPageState extends State<CardiologistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Le mie visite")),
      body: FutureBuilder<List<dynamic>>(
          future: getCardiologyVisits(widget.id, widget.token),
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return CardiologistInsertPage(widget.id);
            }));
          }),
    );
  }
}

class CardiologistInsertPage extends StatefulWidget {
  String doctorID;

  CardiologistInsertPage(this.doctorID);

  @override
  _CardiologistInsertPageState createState() => _CardiologistInsertPageState();
}

class _CardiologistInsertPageState extends State<CardiologistInsertPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController visitIDController = TextEditingController();
  TextEditingController doctorIDController = TextEditingController();
  TextEditingController patientIDController = TextEditingController();

  String selectedKey;

  List<String> keys = <String>[
    'Low',
    'Medium',
    'High',
  ];

  @override
  void initState() {
    doctorIDController.text = widget.doctorID;
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
                  ],
                ))),
      ),
    );
  }

  void insert() {
    if (formKey.currentState.validate()) {}
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
