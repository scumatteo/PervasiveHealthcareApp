import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
